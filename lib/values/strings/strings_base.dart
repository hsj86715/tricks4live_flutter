abstract class StringsBase {
  String appName = 'Tricks4Live';

  String navClickToLogin = 'Click to login';

  String navHome = 'Home';

  String navShare = 'Share';

  String navFeedback = 'Feedback';

  String navAbout = 'About';

  String pageRegister = 'Register';

  String pageLogin = 'Login';

  String pageSubjectDetail = 'Subject Detail';

  String pageUserInfo = 'User Info';

  String waitingForLoad = 'Waiting for loading...';

  String operateSteps = 'Operate Steps: ';

  String hotComments = 'Hot Comments';

  String noComments = 'No Comments';

  String moreComments = 'More Comments';

  String verifyEmailHint =
      'Your Email has not been verified. Send verify email now?';

  String fieldUserName = 'UserName *';

  String fieldUserNameHint = 'Accout name for login.';

  String fieldUserNameEmpty = 'User name is required.';

  String fieldUserNameMatch = 'Please enter only alphabetical characters.';

  String fieldNickName = 'NickName *';

  String fieldNickNameHint = 'What do people call you?';

  String fieldNickNameEmpty = 'Nick name is required.';

  String fieldPassword = 'Password *';

  String fieldPasswordHelper = 'No more than 16 characters.';

  String fieldPasswordRepeat = 'Re-type password';

  String fieldPasswordEmpty = 'Please enter a password.';

  String fieldPasswordTooShort =
      'Password is too short, the minimal length is 6.';

  String fieldPasswordMatch = 'The passwords don\'t match.';

  String fieldEmail = 'Email *';

  String fieldEmailHint = 'Your email address';

  String fieldEmailHelper = 'Find back password, can not be changed.';

  String fieldEmailEmpty = 'Email is required.';

  String fieldEmailMatch = 'Please enter correct email.';

  String userPublished = 'My Published';

  String userImproved = 'My Improved';

  String userVerified = 'My Verified';

  String userFocused = 'My Focused';

  String userCollected = 'My Collected';

  String userCommented = 'My Commented';

  String btnRegister = 'Register';

  String btnToLogin = 'To Login';

  String btnOK = 'OK';

  String btnRetry = 'Retry';

  String btnReedit = 'Re-Edit';

  String btnCancel = 'Cancel';

  String btnLogin = 'Login';

  String btnForgetPwd = 'Forget Password';

  String btnCollect = 'Collect';

  String btnFocus = 'Focus';

  String btnValidate = 'Validate';

  String btnInValidate = 'Invalidate';

  String btnSend = 'Send';

  String btnLoginOut = 'Login Out';

  String formRequiredHint = '* indicates required field';

  String formErrorHint = 'Please fix the errors in red before submitting.';

  get registerWelcome =>
      (String nickName) => 'Regist success, Welcome $nickName join us.';

  get loginWelcome => (String nickName) => '$nickName, Welcome back.';

  String timeMillisLimit = 'Right Now';

  String timeSecondsLimit = ' Seconds Ago';

  String timeMinutesLimit = ' Minutes Ago';

  String timeHoursLimit = ' Hours Ago';

  String timeWeeksLimit = ' Weeks Ago';

  String timeDaysLimit = ' Months Ago';
}
