require 'test_helper'

class RecordsControllerTest < ActionController::TestCase
  setup do
    @record = records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create record" do
    assert_difference('Record.count') do
      post :create, :record => { :f0 => @record.f0, :f1 => @record.f1, :f10 => @record.f10, :f11 => @record.f11, :f12 => @record.f12, :f13 => @record.f13, :f14 => @record.f14, :f15 => @record.f15, :f16 => @record.f16, :f17 => @record.f17, :f18 => @record.f18, :f19 => @record.f19, :f2 => @record.f2, :f20 => @record.f20, :f21 => @record.f21, :f22 => @record.f22, :f23 => @record.f23, :f24 => @record.f24, :f3 => @record.f3, :f4 => @record.f4, :f5 => @record.f5, :f6 => @record.f6, :f7 => @record.f7, :f8 => @record.f8, :f9 => @record.f9 }
    end

    assert_redirected_to record_path(assigns(:record))
  end

  test "should show record" do
    get :show, :id => @record
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @record
    assert_response :success
  end

  test "should update record" do
    put :update, :id => @record, :record => { :f0 => @record.f0, :f1 => @record.f1, :f10 => @record.f10, :f11 => @record.f11, :f12 => @record.f12, :f13 => @record.f13, :f14 => @record.f14, :f15 => @record.f15, :f16 => @record.f16, :f17 => @record.f17, :f18 => @record.f18, :f19 => @record.f19, :f2 => @record.f2, :f20 => @record.f20, :f21 => @record.f21, :f22 => @record.f22, :f23 => @record.f23, :f24 => @record.f24, :f3 => @record.f3, :f4 => @record.f4, :f5 => @record.f5, :f6 => @record.f6, :f7 => @record.f7, :f8 => @record.f8, :f9 => @record.f9 }
    assert_redirected_to record_path(assigns(:record))
  end

  test "should destroy record" do
    assert_difference('Record.count', -1) do
      delete :destroy, :id => @record
    end

    assert_redirected_to records_path
  end
end
