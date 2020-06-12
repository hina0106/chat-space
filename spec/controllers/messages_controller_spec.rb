require 'rails_helper'

describe MessagesController do
  # 複数のexampleで同一のインスタンスを使いたい場合、letメソッドを利用する
  let(:group) { create(:group) }
  let(:user) { create(:user) }

  describe '#index' do
    context 'ログインしている場合' do
      # beforeブロック内は、各exampleが実行される直前に、毎回実行される
      # 今回の共通処理は、「ログインする」「擬似的にindexアクションを動かすリクエストを行う」
      before do
        login user # controller_macros.rbのloginメソッド
        get :index, params: {group_id: group.id}
      end

      it "@messageに期待した値が入っていること" do
        # 「assigns(:message)」：@messageを参照
        expect(assigns(:message)).to be_a_new(Message)
      end

      it "@groupに期待した値が入っていること" do
        expect(assigns(:group)).to eq group
      end

      it 'index.html.hamlに遷移すること' do
        expect(response).to render_template :index
      end
    end
  
    context 'ログインしていない場合' do
      before do
        get :index, params: { group_id: group.id}
      end

      it 'ログイン画面にリダイレクトすること' do
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe '#create' do
    # createアクションをリクエストする際の引数を定義
    let(:params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message) } }

    context 'ログインしている場合' do
      before do
        login user
      end

      context '保存に成功した場合' do
        # expectの引数が長くなってしまう場合は記述を切り出す
        subject {
          post :create,
          params: params
        }

        it 'messageを保存すること' do
          expect{ subject }.to change(Message, :count).by(1)
        end

        it 'group_messages_pathへリダイレクトすること' do
          subject
          expect(response).to redirect_to(group_messages_path(group))
        end
      end

      context '保存に失敗した場合' do
        let(:invalid_params) { { group_id: group.id, user_id: user.id, message: attributes_for(:message, body: nil, image: nil) } }

        subject {
          post :create,
          params: invalid_params
        }

        it 'messageを保存しないこと' do
          expect{ subject }.not_to change(Message, :count)
        end

        it 'index.html.hamlに遷移すること' do
          subject
          expect(response).to render_template :index
        end
      end
    end

    context 'ログインしていない場合' do

      it "new_user_session_pathにリダイレクトすること" do
        post :create, params: params
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

end