import 'strings_base.dart';

class StringsEN extends StringsBase {
  @override
  final String appName = 'Tricks4Live';
  @override
  final String navClickToLogin = 'Click to login';
  @override
  final String navHome = 'Home';
  @override
  final String navShare = 'Share';
  @override
  final String navFeedback = 'Feedback';
  @override
  final String navAbout = 'About';
  @override
  final String pageRegister = 'Register';
  @override
  final String pageLogin = 'Login';
  @override
  final String pageSubjectDetail = 'Subject Detail';
  @override
  final String pageUserInfo = 'User Info';
  @override
  final String waitingForLoad = 'Waiting for loading...';
  @override
  final String operateSteps = 'Operate Steps: ';
  @override
  final String hotComments = 'Hot Comments';
  @override
  final String noComments = 'No Comments';
  @override
  final String moreComments = 'More Comments';
  @override
  final String verifyEmailHint =
      'Your Email has not been verified. Send verify email now?';
  @override
  final String fieldUserName = 'UserName *';
  @override
  final String fieldUserNameHint = 'Accout name for login.';
  @override
  final String fieldUserNameEmpty = 'User name is required.';
  @override
  final String fieldUserNameMatch =
      'Please enter only alphabetical characters.';
  @override
  final String fieldNickName = 'NickName *';
  @override
  final String fieldNickNameHint = 'What do people call you?';
  @override
  final String fieldNickNameEmpty = 'Nick name is required.';
  @override
  final String fieldPassword = 'Password *';
  @override
  final String fieldPasswordHelper = 'No more than 16 characters.';
  @override
  final String fieldPasswordRepeat = 'Re-type password';
  @override
  final String fieldPasswordEmpty = 'Please enter a password.';
  @override
  final String fieldPasswordTooShort =
      'Password is too short, the minimal length is 6.';
  @override
  final String fieldPasswordMatch = 'The passwords don\'t match.';
  @override
  final String fieldEmail = 'Email *';
  @override
  final String fieldEmailHint = 'Your email address';
  @override
  final String fieldEmailHelper = 'Find back password, can not be changed.';
  @override
  final String fieldEmailEmpty = 'Email is required.';
  @override
  final String fieldEmailMatch = 'Please enter correct email.';
  @override
  final String userPublished = 'My Published';
  @override
  final String userImproved = 'My Improved';
  @override
  final String userVerified = 'My Verified';
  @override
  final String userFocused = 'My Focused';
  @override
  final String userCollected = 'My Collected';
  @override
  final String userCommented = 'My Commented';
  @override
  final String btnRegister = 'Register';
  @override
  final String btnToLogin = 'To Login';
  @override
  final String btnOK = 'OK';
  @override
  final String btnRetry = 'Retry';
  @override
  final String btnReedit = 'Re-Edit';
  @override
  final String btnCancel = 'Cancel';
  @override
  final String btnLogin = 'Login';
  @override
  final String btnForgetPwd = 'Forget Password';
  @override
  final String btnCollect = 'Collect';
  @override
  final String btnFocus = 'Focus';
  @override
  final String btnValidate = 'Validate';
  @override
  final String btnInValidate = 'Invalidate';
  @override
  final String btnSend = 'Send';
  @override
  final String btnLoginOut = 'Login Out';
  @override
  final String formRequiredHint = '* indicates required field';
  @override
  final String formErrorHint =
      'Please fix the errors in red before submitting.';

  @override
  get registerWelcome =>
      (String nickName) => 'Regist success, Welcome $nickName join us.';

  @override
  get loginWelcome => (String nickName) => '$nickName, Welcome back.';
  @override
  final String timeMillisLimit = 'Right Now';
  @override
  final String timeSecondsLimit = ' Seconds Ago';
  @override
  final String timeMinutesLimit = ' Minutes Ago';
  @override
  final String timeHoursLimit = ' Hours Ago';
  @override
  final String timeWeeksLimit = ' Weeks Ago';
  @override
  final String timeDaysLimit = ' Months Ago';
}
