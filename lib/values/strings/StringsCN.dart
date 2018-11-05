import 'StringsBase.dart';

class StringsCN extends StringsBase {
  @override
  final String appName = '魔法生活';
  @override
  final String navClickToLogin = '点击登录';
  @override
  final String navHome = '主页';
  @override
  final String navShare = '分享';
  @override
  final String navFeedback = '反馈';
  @override
  final String navAbout = '关于';
  @override
  final String pageRegister = '注册';
  @override
  final String pageLogin = '登录';
  @override
  final String pageUserInfo = '用户信息';
  @override
  final String pageSubjectDetail = '详情';
  @override
  final String waitingForLoad = '加载中。。。';
  @override
  final String operateSteps = '操作步骤：';
  @override
  final String hotComments = '热评';
  @override
  final String noComments = '暂无评论';
  @override
  final String moreComments = '更多评论';
  @override
  final String verifyEmailHint = '你的邮箱还没有经过验证，现在发送验证邮件？';
  @override
  final String fieldUserName = '用户名 *';
  @override
  final String fieldUserNameHint = '用于登录的账户名称。';
  @override
  final String fieldUserNameEmpty = '用户名称不能为空。';
  @override
  final String fieldUserNameMatch = '用户名称只能使用英文字母。';
  @override
  final String fieldNickName = '昵称 *';
  @override
  final String fieldNickNameHint = '其他人怎么称呼您？';
  @override
  final String fieldNickNameEmpty = '昵称不能为空。';
  @override
  final String fieldPassword = '密码 *';
  @override
  final String fieldPasswordHelper = '最长16个字符。';
  @override
  final String fieldPasswordRepeat = '重复输入密码';
  @override
  final String fieldPasswordEmpty = '密码不能为空，请输入密码';
  @override
  final String fieldPasswordTooShort = '密码过短，最少为6位。';
  @override
  final String fieldPasswordMatch = '两次输入的密码不一致。';
  @override
  final String fieldEmail = '邮箱 *';
  @override
  final String fieldEmailHint = '您的电子邮箱地址';
  @override
  final String fieldEmailHelper = '用于找回密码，不能修改。';
  @override
  final String fieldEmailEmpty = '电子邮箱不能为空。';
  @override
  final String fieldEmailMatch = '请输入正确的邮箱地址。';
  @override
  final String userPublished = '我发布的';
  @override
  final String userImproved = '我参与改进的';
  @override
  final String userVerified = '我参与验证的';
  @override
  final String userFocused = '我的关注';
  @override
  final String userCollected = '我的收藏';
  @override
  final String userCommented = '我的评论';
  @override
  final String btnRegister = '注册';
  @override
  final String btnToLogin = '去登录';
  @override
  final String btnOK = '确定';
  @override
  final String btnRetry = '重试';
  @override
  final String btnReedit = '重写';
  @override
  final String btnCancel = '取消';
  @override
  final String btnLogin = '登录';
  @override
  final String btnForgetPwd = '找回密码';
  @override
  final String btnCollect = '收藏';
  @override
  final String btnFocus = '关注';
  @override
  final String btnValidate = '有效';
  @override
  final String btnInValidate = '无效';
  @override
  final String btnSend = '发送';
  @override
  final String btnLoginOut = '退出登录';
  @override
  final String formRequiredHint = '* 标识为必填项目';
  @override
  final String formErrorHint = '请在提交前修复标红的错误项。';

  @override
  get registerWelcome => (String nickName) => '注册成功，欢迎 $nickName 加入。';

  @override
  get loginWelcome => (String nickName) => '$nickName，欢迎回来。';
  @override
  final String timeMillisLimit = '刚刚';
  @override
  final String timeSecondsLimit = ' 秒前';
  @override
  final String timeMinutesLimit = ' 分钟前';
  @override
  final String timeHoursLimit = ' 小时前';
  @override
  final String timeWeeksLimit = ' 周前';
  @override
  final String timeDaysLimit = ' 天前';
}
