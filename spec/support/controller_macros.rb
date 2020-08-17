module ControllerMacros
  # loginメソッドを定義
  # 参考URL https://master.tech-camp.in/curriculums/4343
  def login(user)
    @request.env["devise.mapping"] = Devise.mappings[:user]
    sign_in user
  end
end