module SessionsHelper
  #记录登入的用户id
  def log_in(user)
    session[:user_id] = user.id     #session 方法創建 cookie 會自動加密 所以是安全的
  end
  #返回当前登录的用户
  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
  end
  
  def logged_in?
    !current_user.nil?
  end
  
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
