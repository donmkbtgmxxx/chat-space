require 'rails_helper'

describe MessagesController do
  #  letを利用してテスト中使用するインスタンスを定義
  #  letメソッドは呼び出された際に初めて実行される、遅延評価という特徴を持つ。
  #  letメソッドは初回の呼び出し時のみ実行され、複数回行われる処理を一度の処理で実装できるため、テストを高速にすることができる。
  #  一度実行された後は常に同じ値が返って来るため、テストで使用したいオブジェクトの定義に適している。
  let(:group) { create(:group) }
  let(:user) { create(:user) }
  let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

  describe '#index' do

    context 'log in' do
      # この中にログインしている場合のテストを記述
      # beforeブロックの内部に記述された処理は、各exampleが実行される直前に、毎回実行される。
      # beforeブロックに共通の処理をまとめることで、コードの量が減り、読みやすいテストを書くことができる。
      # 今回の場合は、「ログインをする」、「擬似的にindexアクションを動かすリクエストを行う」が共通の処理となるため、beforeの内部に記述している。

      before do
        login user
        get :index, params: { group_id: group.id }
      end
      # この中にログインしている場合のテストを記述
      it 'assigns @message' do
        expect(assigns(:message)).to be_a_new(Message)
      end

      it 'assigns @group' do
        expect(assigns(:group)).to eq group
      end

      it 'renders index' do
        expect(response).to render_template :index
      end
    end

    context 'not log in' do
      # この中にログインしていない場合のテストを記述
      before do
        get :index, params: { group_id: group.id }
      end
      # この中にログインしていない場合のテストを記述
      it 'redirects to new_user_session_path' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do

    context 'log in' do
      before do
        login user
      end

      context 'can save' do
        subject {
          post :create,
          params: params
        }

        it 'count up message' do
          expect{ subject }.to change(Message, :count).by(1)
        end

        it 'redirects to group_messages_path' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context 'can not save' do
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, content: nil, image: nil) } }

        subject {
          post :create,
          params: invalid_params
        }

        it 'does not count up' do
          expect{ subject }.not_to change(Message, :count)
        end

        it 'renders index' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'not log in' do

      it 'redirects to new_user_session_path' do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end