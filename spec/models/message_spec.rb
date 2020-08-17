require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#create' do
    context 'can save' do
    # この中にメッセージを保存できる場合のテストを記述

    # 参考URL https://master.tech-camp.in/curriculums/4342
      # 下記は、メッセージがあれば保存できることの確認
      it 'is valid with content' do
        expect(build(:message, image: nil)).to be_valid
      end

      # 下記は、画像があれば保存できることの確認
      it 'is valid with image' do
        expect(build(:message, content: nil)).to be_valid
      end

      # 下記は、メッセージと画像両方あれば保存できることの確認
      it 'is valid with content and image' do
        expect(build(:message)).to be_valid
      end
    end

    context 'can not save' do
    # この中にメッセージを保存できない場合のテストを記述
      
      # 下記は、メッセージも画像も無いと保存できない場合の確認
      # valid?メソッドを利用したインスタンスに対して、errorsメソッドを使用することによって、バリデーションにより保存ができない状態である場合なぜできないのかを確認することができる。
      it 'is invalid without content and image' do
        message = build(:message, content: nil, image: nil)
        message.valid?
        expect(message.errors[:content]).to include("を入力してください")
      end


      # 下記は、user_idが無いと保存できない かつ group_idが無いと保存できない場合の確認
      # メッセージも画像もないと保存できない場合と同じ方法でテストを書くことができる
      it 'is invalid without group_id' do
        message = build(:message, group_id: nil)
        message.valid?
        expect(message.errors[:group]).to include("を入力してください")
      end

      it 'is invalid without user_id' do
        message = build(:message, user_id: nil)
        message.valid?
        expect(message.errors[:user]).to include("を入力してください")
      end
    end
  end
end