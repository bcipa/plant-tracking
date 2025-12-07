require "test_helper"

class PlantLogsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @plant_log = plant_logs(:one)
  end

  test "should get index" do
    get plant_logs_url
    assert_response :success
  end

  test "should get new" do
    get new_plant_log_url
    assert_response :success
  end

  test "should create plant_log" do
    assert_difference("PlantLog.count") do
      post plant_logs_url, params: { plant_log: { image: @plant_log.image, plant_id: @plant_log.plant_id, watered: @plant_log.watered } }
    end

    assert_redirected_to plant_log_url(PlantLog.last)
  end

  test "should show plant_log" do
    get plant_log_url(@plant_log)
    assert_response :success
  end

  test "should get edit" do
    get edit_plant_log_url(@plant_log)
    assert_response :success
  end

  test "should update plant_log" do
    patch plant_log_url(@plant_log), params: { plant_log: { image: @plant_log.image, plant_id: @plant_log.plant_id, watered: @plant_log.watered } }
    assert_redirected_to plant_log_url(@plant_log)
  end

  test "should destroy plant_log" do
    assert_difference("PlantLog.count", -1) do
      delete plant_log_url(@plant_log)
    end

    assert_redirected_to plant_logs_url
  end
end
