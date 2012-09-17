require 'test_helper'

class CloseRelationsControllerTest < ActionController::TestCase
  setup do
    @close_relation = close_relations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:close_relations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create close_relation" do
    assert_difference('CloseRelation.count') do
      post :create, :close_relation => { :r0 => @close_relation.r0, :r1 => @close_relation.r1, :r2 => @close_relation.r2, :r3 => @close_relation.r3, :r4 => @close_relation.r4, :r5 => @close_relation.r5, :r6 => @close_relation.r6, :r7 => @close_relation.r7, :r8 => @close_relation.r8, :r9 => @close_relation.r9, :userid => @close_relation.userid }
    end

    assert_redirected_to close_relation_path(assigns(:close_relation))
  end

  test "should show close_relation" do
    get :show, :id => @close_relation
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @close_relation
    assert_response :success
  end

  test "should update close_relation" do
    put :update, :id => @close_relation, :close_relation => { :r0 => @close_relation.r0, :r1 => @close_relation.r1, :r2 => @close_relation.r2, :r3 => @close_relation.r3, :r4 => @close_relation.r4, :r5 => @close_relation.r5, :r6 => @close_relation.r6, :r7 => @close_relation.r7, :r8 => @close_relation.r8, :r9 => @close_relation.r9, :userid => @close_relation.userid }
    assert_redirected_to close_relation_path(assigns(:close_relation))
  end

  test "should destroy close_relation" do
    assert_difference('CloseRelation.count', -1) do
      delete :destroy, :id => @close_relation
    end

    assert_redirected_to close_relations_path
  end
end
