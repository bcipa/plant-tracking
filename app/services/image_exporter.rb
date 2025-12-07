class ImageExporter
  BASE_PATH = ENV["IMAGE_DIR"]

  class ExportResult
    attr_accessor :success_count, :skipped_count, :failures

    def initialize
      @success_count = 0
      @skipped_count = 0
      @failures = [] 
    end
  end

  def initialize(plant_log, overwrite: false, logger: Rails.logger)
    @plant_log = plant_log
    @plant = plant_log&.plant
    @overwrite = overwrite
    @logger = logger
  end

  def call
    raise "no plant_log" unless @plant_log
    return nil unless @plant_log.image.attached?

    ensure_base_path!
    FileUtils.mkdir_p(export_dir)

    if File.exist?(export_path) && !@overwrite
      @logger.info("[ImageExporter] skipping existing: #{export_path}")
      return :skipped
    end

    Tempfile.create(["plant_log_#{@plant_log.id}", File.extname(export_path)]) do |tmp|
      tmp.binmode
      tmp.write(@plant_log.image.download)
      tmp.flush
      FileUtils.mv(tmp.path, export_path)
    end

    @logger.info("[ImageExporter] exported plant_log=#{@plant_log.id} -> #{export_path}")
    export_path
  rescue => e
    @logger.error("[ImageExporter] failed plant_log=#{@plant_log.id}: #{e.class} #{e.message}")
    raise
  end

  def self.export_all(overwrite: false, logger: Rails.logger)
    result = ExportResult.new
    ensure_base_path_exists!

    Plant.includes(:plant_logs).find_each do |plant|
      plant.plant_logs.each do |log|
        begin
          r = new(log, overwrite: overwrite, logger: logger).call
          if r == :skipped
            result.skipped_count += 1
          else
            result.success_count += 1
          end
        rescue => e
          result.failures << { plant_log_id: log.id, plant_id: plant.id, path: new(log).send(:export_path), error: "#{e.class}: #{e.message}" }
          logger.error("[ImageExporter.export_all] failure for plant_log=#{log.id}: #{e.class}: #{e.message}")
        end
      end
    end

    logger.info("[ImageExporter.export_all] done. success=#{result.success_count} skipped=#{result.skipped_count} failures=#{result.failures.length}")
    result
  end

  private

  def self.ensure_base_path_exists!
    unless File.directory?(BASE_PATH)
      raise "Base path #{BASE_PATH.inspect} does not exist. Create it from WSL: `mkdir -p #{BASE_PATH}` and ensure WSL can write to it."
    end

    unless File.writable?(BASE_PATH)
      raise "Base path #{BASE_PATH.inspect} is not writable by this user. Check mount options / permissions."
    end
  end

  def ensure_base_path!
    self.class.ensure_base_path_exists!
  end

  def export_dir
    File.join(BASE_PATH, sanitize(@plant&.name.to_s.presence || "unknown_plant_#{@plant&.id}"))
  end

  def export_path
    date_str = @plant_log.created_at.utc.strftime("%Y-%m-%d_%H%M%S")
    filename = "#{date_str}.jpg"
    File.join(export_dir, sanitize(filename))
  end

  def sanitize(str)
    str.to_s.gsub(/[^0-9A-Za-z.\-_\s]/, "_").strip
  end
end
