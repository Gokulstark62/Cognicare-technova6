import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'CogniCare'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Brighter Days • Stronger Connections'**
  String get tagline;

  /// No description provided for @taglineLong.
  ///
  /// In en, this message translates to:
  /// **'Better Minds • Happier Families • Together Always'**
  String get taglineLong;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logOut;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get or;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @mobileOrEmail.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number / Email'**
  String get mobileOrEmail;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @familyCaregiver.
  ///
  /// In en, this message translates to:
  /// **'Family / Caregiver'**
  String get familyCaregiver;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @chooseYourLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Your Language'**
  String get chooseYourLanguage;

  /// No description provided for @selectPreferredLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language to continue'**
  String get selectPreferredLanguage;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @gamesTitle.
  ///
  /// In en, this message translates to:
  /// **'Brain Games'**
  String get gamesTitle;

  /// No description provided for @tasksTitle.
  ///
  /// In en, this message translates to:
  /// **'My Daily Tasks'**
  String get tasksTitle;

  /// No description provided for @familyTitle.
  ///
  /// In en, this message translates to:
  /// **'My Family'**
  String get familyTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @memoriesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Family Memories'**
  String get memoriesTitle;

  /// No description provided for @wellnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Wellness & Relax'**
  String get wellnessTitle;

  /// No description provided for @goodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get goodMorning;

  /// No description provided for @goodAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get goodAfternoon;

  /// No description provided for @goodEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get goodEvening;

  /// No description provided for @goodNight.
  ///
  /// In en, this message translates to:
  /// **'Good Night'**
  String get goodNight;

  /// No description provided for @haveWonderfulDay.
  ///
  /// In en, this message translates to:
  /// **'Have a wonderful day!'**
  String get haveWonderfulDay;

  /// No description provided for @todaysProgress.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Progress'**
  String get todaysProgress;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @hydration.
  ///
  /// In en, this message translates to:
  /// **'Hydration'**
  String get hydration;

  /// No description provided for @nextAppointment.
  ///
  /// In en, this message translates to:
  /// **'Next Appointment'**
  String get nextAppointment;

  /// No description provided for @noneScheduled.
  ///
  /// In en, this message translates to:
  /// **'None scheduled'**
  String get noneScheduled;

  /// No description provided for @noMedicines.
  ///
  /// In en, this message translates to:
  /// **'No medicines'**
  String get noMedicines;

  /// No description provided for @glasses.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glasses;

  /// No description provided for @taken.
  ///
  /// In en, this message translates to:
  /// **'taken'**
  String get taken;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @todaysSchedule.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule;

  /// No description provided for @nothingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled yet'**
  String get nothingScheduled;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @logWater.
  ///
  /// In en, this message translates to:
  /// **'Log Water'**
  String get logWater;

  /// No description provided for @myMedicines.
  ///
  /// In en, this message translates to:
  /// **'My Medicines'**
  String get myMedicines;

  /// No description provided for @myRoutine.
  ///
  /// In en, this message translates to:
  /// **'My Daily Routine'**
  String get myRoutine;

  /// No description provided for @playGames.
  ///
  /// In en, this message translates to:
  /// **'Play Games'**
  String get playGames;

  /// No description provided for @findMatchingPairs.
  ///
  /// In en, this message translates to:
  /// **'Find Matching Pairs'**
  String get findMatchingPairs;

  /// No description provided for @tapCardToFlip.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to flip it'**
  String get tapCardToFlip;

  /// No description provided for @buildTheWord.
  ///
  /// In en, this message translates to:
  /// **'Build the Word'**
  String get buildTheWord;

  /// No description provided for @arrangeLetters.
  ///
  /// In en, this message translates to:
  /// **'Arrange letters to form words'**
  String get arrangeLetters;

  /// No description provided for @identifyObjects.
  ///
  /// In en, this message translates to:
  /// **'Identify objects and places'**
  String get identifyObjects;

  /// No description provided for @rememberSequence.
  ///
  /// In en, this message translates to:
  /// **'Remember the sequence'**
  String get rememberSequence;

  /// No description provided for @memoryMatch.
  ///
  /// In en, this message translates to:
  /// **'Memory Match'**
  String get memoryMatch;

  /// No description provided for @wordBuilder.
  ///
  /// In en, this message translates to:
  /// **'Word Builder'**
  String get wordBuilder;

  /// No description provided for @pictureRecognition.
  ///
  /// In en, this message translates to:
  /// **'Picture Recognition'**
  String get pictureRecognition;

  /// No description provided for @numberSequence.
  ///
  /// In en, this message translates to:
  /// **'Number Sequence'**
  String get numberSequence;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @veryEasy.
  ///
  /// In en, this message translates to:
  /// **'Very Easy'**
  String get veryEasy;

  /// No description provided for @exerciseYourMind.
  ///
  /// In en, this message translates to:
  /// **'Exercise your mind. Have fun and keep your brain active!'**
  String get exerciseYourMind;

  /// No description provided for @findMatchingPairsSub.
  ///
  /// In en, this message translates to:
  /// **'Find matching pairs'**
  String get findMatchingPairsSub;

  /// No description provided for @arrangeLettersSub.
  ///
  /// In en, this message translates to:
  /// **'Arrange letters to form words'**
  String get arrangeLettersSub;

  /// No description provided for @identifyObjectsSub.
  ///
  /// In en, this message translates to:
  /// **'Identify objects and places'**
  String get identifyObjectsSub;

  /// No description provided for @rememberSequenceSub.
  ///
  /// In en, this message translates to:
  /// **'Remember the sequence'**
  String get rememberSequenceSub;

  /// No description provided for @todaysTasks.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Tasks'**
  String get todaysTasks;

  /// No description provided for @keepOnTrack.
  ///
  /// In en, this message translates to:
  /// **'Keep on track, one step at a time'**
  String get keepOnTrack;

  /// No description provided for @stayConnected.
  ///
  /// In en, this message translates to:
  /// **'Stay connected with your loved ones'**
  String get stayConnected;

  /// No description provided for @online.
  ///
  /// In en, this message translates to:
  /// **'Online'**
  String get online;

  /// No description provided for @lastSeen.
  ///
  /// In en, this message translates to:
  /// **'Last seen recently'**
  String get lastSeen;

  /// No description provided for @youAreDoingGreat.
  ///
  /// In en, this message translates to:
  /// **'You are doing great!'**
  String get youAreDoingGreat;

  /// No description provided for @keepSmallSteps.
  ///
  /// In en, this message translates to:
  /// **'Keep taking small steps.'**
  String get keepSmallSteps;

  /// No description provided for @moves.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @pairs.
  ///
  /// In en, this message translates to:
  /// **'Pairs'**
  String get pairs;

  /// No description provided for @accuracy.
  ///
  /// In en, this message translates to:
  /// **'Accuracy'**
  String get accuracy;

  /// No description provided for @attempts.
  ///
  /// In en, this message translates to:
  /// **'Attempts'**
  String get attempts;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Level'**
  String get level;

  /// No description provided for @correct.
  ///
  /// In en, this message translates to:
  /// **'Correct'**
  String get correct;

  /// No description provided for @wrong.
  ///
  /// In en, this message translates to:
  /// **'Wrong'**
  String get wrong;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @round.
  ///
  /// In en, this message translates to:
  /// **'Round'**
  String get round;

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @nextWord.
  ///
  /// In en, this message translates to:
  /// **'Next Word'**
  String get nextWord;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @chooseDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Choose Difficulty'**
  String get chooseDifficulty;

  /// No description provided for @chooseAnIcon.
  ///
  /// In en, this message translates to:
  /// **'Choose an Icon'**
  String get chooseAnIcon;

  /// No description provided for @nextGame.
  ///
  /// In en, this message translates to:
  /// **'Next game'**
  String get nextGame;

  /// No description provided for @greatJobLevelUp.
  ///
  /// In en, this message translates to:
  /// **'Great job! Level up!'**
  String get greatJobLevelUp;

  /// No description provided for @letsTryEasier.
  ///
  /// In en, this message translates to:
  /// **'Let\'s try an easier level'**
  String get letsTryEasier;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations!'**
  String get congratulations;

  /// No description provided for @sessionComplete.
  ///
  /// In en, this message translates to:
  /// **'Session Complete!'**
  String get sessionComplete;

  /// No description provided for @correct2.
  ///
  /// In en, this message translates to:
  /// **'Correct!'**
  String get correct2;

  /// No description provided for @youMatchedAllPairs.
  ///
  /// In en, this message translates to:
  /// **'You matched all pairs!'**
  String get youMatchedAllPairs;

  /// No description provided for @youBuiltWord.
  ///
  /// In en, this message translates to:
  /// **'You built: {word}'**
  String youBuiltWord(String word);

  /// No description provided for @youGotOutOf.
  ///
  /// In en, this message translates to:
  /// **'You got {correct} out of {total}'**
  String youGotOutOf(int correct, int total);

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @ofWord.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofWord;

  /// No description provided for @myMedicinesTitle.
  ///
  /// In en, this message translates to:
  /// **'My Medicines'**
  String get myMedicinesTitle;

  /// No description provided for @todaysMedicines.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Medicines'**
  String get todaysMedicines;

  /// No description provided for @tapMedicineWhenTaken.
  ///
  /// In en, this message translates to:
  /// **'Tap a medicine when you take it'**
  String get tapMedicineWhenTaken;

  /// No description provided for @addMedicine.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicine;

  /// No description provided for @editMedicine.
  ///
  /// In en, this message translates to:
  /// **'Edit Medicine'**
  String get editMedicine;

  /// No description provided for @medicineName.
  ///
  /// In en, this message translates to:
  /// **'Medicine Name'**
  String get medicineName;

  /// No description provided for @dosage.
  ///
  /// In en, this message translates to:
  /// **'Dosage'**
  String get dosage;

  /// No description provided for @purpose.
  ///
  /// In en, this message translates to:
  /// **'Purpose'**
  String get purpose;

  /// No description provided for @timeLabel.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeLabel;

  /// No description provided for @medicineHintName.
  ///
  /// In en, this message translates to:
  /// **'e.g., Amlodipine'**
  String get medicineHintName;

  /// No description provided for @medicineHintDosage.
  ///
  /// In en, this message translates to:
  /// **'e.g., 5mg'**
  String get medicineHintDosage;

  /// No description provided for @medicineHintPurpose.
  ///
  /// In en, this message translates to:
  /// **'e.g., Blood pressure'**
  String get medicineHintPurpose;

  /// No description provided for @pleaseEnterMedicineName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the medicine name'**
  String get pleaseEnterMedicineName;

  /// No description provided for @pleaseEnterDosage.
  ///
  /// In en, this message translates to:
  /// **'Please enter the dosage'**
  String get pleaseEnterDosage;

  /// No description provided for @pleaseEnterPurpose.
  ///
  /// In en, this message translates to:
  /// **'Please enter the purpose'**
  String get pleaseEnterPurpose;

  /// No description provided for @addMedicineButton.
  ///
  /// In en, this message translates to:
  /// **'Add Medicine'**
  String get addMedicineButton;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @deleteMedicine.
  ///
  /// In en, this message translates to:
  /// **'Delete Medicine?'**
  String get deleteMedicine;

  /// No description provided for @deleteMedicineMessage.
  ///
  /// In en, this message translates to:
  /// **'This will remove this medicine from your list.'**
  String get deleteMedicineMessage;

  /// No description provided for @allDoneForToday.
  ///
  /// In en, this message translates to:
  /// **'All done for today! 🎉'**
  String get allDoneForToday;

  /// No description provided for @noMedicinesYet.
  ///
  /// In en, this message translates to:
  /// **'No medicines yet'**
  String get noMedicinesYet;

  /// No description provided for @tapAddFirstMedicine.
  ///
  /// In en, this message translates to:
  /// **'Tap + Add to create your first one'**
  String get tapAddFirstMedicine;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @afternoon.
  ///
  /// In en, this message translates to:
  /// **'Afternoon'**
  String get afternoon;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @night.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get night;

  /// No description provided for @stayHydrated.
  ///
  /// In en, this message translates to:
  /// **'Stay Hydrated'**
  String get stayHydrated;

  /// No description provided for @trackWaterIntake.
  ///
  /// In en, this message translates to:
  /// **'Track your water intake'**
  String get trackWaterIntake;

  /// No description provided for @goalGlassesToday.
  ///
  /// In en, this message translates to:
  /// **'Goal: {goal} glasses today'**
  String goalGlassesToday(int goal);

  /// No description provided for @glassesToday.
  ///
  /// In en, this message translates to:
  /// **'glasses today'**
  String get glassesToday;

  /// No description provided for @goalReached.
  ///
  /// In en, this message translates to:
  /// **'Goal reached! Well done 🎉'**
  String get goalReached;

  /// No description provided for @keepGoingMoreToGo.
  ///
  /// In en, this message translates to:
  /// **'Keep going! {n} more to go'**
  String keepGoingMoreToGo(int n);

  /// No description provided for @quickAdd.
  ///
  /// In en, this message translates to:
  /// **'Quick Add'**
  String get quickAdd;

  /// No description provided for @glass.
  ///
  /// In en, this message translates to:
  /// **'glass'**
  String get glass;

  /// No description provided for @glassesWord.
  ///
  /// In en, this message translates to:
  /// **'glasses'**
  String get glassesWord;

  /// No description provided for @undoLast.
  ///
  /// In en, this message translates to:
  /// **'Undo Last'**
  String get undoLast;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @resetToday.
  ///
  /// In en, this message translates to:
  /// **'Reset Today?'**
  String get resetToday;

  /// No description provided for @resetTodayMessage.
  ///
  /// In en, this message translates to:
  /// **'This will clear today\'s water log.'**
  String get resetTodayMessage;

  /// No description provided for @todaysLog.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Log'**
  String get todaysLog;

  /// No description provided for @noWaterLogged.
  ///
  /// In en, this message translates to:
  /// **'No water logged yet'**
  String get noWaterLogged;

  /// No description provided for @tapPlusOneToStart.
  ///
  /// In en, this message translates to:
  /// **'Tap +1 to start tracking'**
  String get tapPlusOneToStart;

  /// No description provided for @dailyGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Goal'**
  String get dailyGoal;

  /// No description provided for @howManyGlasses.
  ///
  /// In en, this message translates to:
  /// **'How many glasses per day?'**
  String get howManyGlasses;

  /// No description provided for @saveGoal.
  ///
  /// In en, this message translates to:
  /// **'Save Goal'**
  String get saveGoal;

  /// No description provided for @myDailyRoutine.
  ///
  /// In en, this message translates to:
  /// **'My Daily Routine'**
  String get myDailyRoutine;

  /// No description provided for @todaysSchedule2.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Schedule'**
  String get todaysSchedule2;

  /// No description provided for @activitiesPlanned.
  ///
  /// In en, this message translates to:
  /// **'{n} activities planned'**
  String activitiesPlanned(int n);

  /// No description provided for @addActivity.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get addActivity;

  /// No description provided for @editActivity.
  ///
  /// In en, this message translates to:
  /// **'Edit Activity'**
  String get editActivity;

  /// No description provided for @activityName.
  ///
  /// In en, this message translates to:
  /// **'Activity Name'**
  String get activityName;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @activityHintName.
  ///
  /// In en, this message translates to:
  /// **'e.g., Morning Walk'**
  String get activityHintName;

  /// No description provided for @activityHintDesc.
  ///
  /// In en, this message translates to:
  /// **'e.g., 20 minutes around the park'**
  String get activityHintDesc;

  /// No description provided for @pleaseEnterActivityName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a name'**
  String get pleaseEnterActivityName;

  /// No description provided for @pleaseAddDescription.
  ///
  /// In en, this message translates to:
  /// **'Please add a short description'**
  String get pleaseAddDescription;

  /// No description provided for @addActivityButton.
  ///
  /// In en, this message translates to:
  /// **'Add Activity'**
  String get addActivityButton;

  /// No description provided for @deleteActivity.
  ///
  /// In en, this message translates to:
  /// **'Delete Activity?'**
  String get deleteActivity;

  /// No description provided for @deleteActivityMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this activity from your routine?'**
  String get deleteActivityMessage;

  /// No description provided for @noActivitiesYet.
  ///
  /// In en, this message translates to:
  /// **'No activities yet'**
  String get noActivitiesYet;

  /// No description provided for @tapAddPlanDay.
  ///
  /// In en, this message translates to:
  /// **'Tap + Add to plan your day'**
  String get tapAddPlanDay;

  /// No description provided for @myAppointments.
  ///
  /// In en, this message translates to:
  /// **'My Appointments'**
  String get myAppointments;

  /// No description provided for @doctorVisits.
  ///
  /// In en, this message translates to:
  /// **'Doctor Visits'**
  String get doctorVisits;

  /// No description provided for @upcomingCount.
  ///
  /// In en, this message translates to:
  /// **'{n} upcoming'**
  String upcomingCount(int n);

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @todayWord.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayWord;

  /// No description provided for @tomorrowWord.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get tomorrowWord;

  /// No description provided for @yesterdayWord.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get yesterdayWord;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'In {n} days'**
  String inDays(int n);

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{n} days ago'**
  String daysAgo(int n);

  /// No description provided for @addAppointment.
  ///
  /// In en, this message translates to:
  /// **'Add Appointment'**
  String get addAppointment;

  /// No description provided for @editAppointment.
  ///
  /// In en, this message translates to:
  /// **'Edit Appointment'**
  String get editAppointment;

  /// No description provided for @doctorName.
  ///
  /// In en, this message translates to:
  /// **'Doctor Name'**
  String get doctorName;

  /// No description provided for @specialty.
  ///
  /// In en, this message translates to:
  /// **'Specialty'**
  String get specialty;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @doctorHintName.
  ///
  /// In en, this message translates to:
  /// **'e.g., Dr. Sharma'**
  String get doctorHintName;

  /// No description provided for @doctorHintSpecialty.
  ///
  /// In en, this message translates to:
  /// **'e.g., Cardiologist'**
  String get doctorHintSpecialty;

  /// No description provided for @doctorHintLocation.
  ///
  /// In en, this message translates to:
  /// **'e.g., Apollo Clinic'**
  String get doctorHintLocation;

  /// No description provided for @doctorHintNotes.
  ///
  /// In en, this message translates to:
  /// **'e.g., Bring reports'**
  String get doctorHintNotes;

  /// No description provided for @pleaseEnterDoctorName.
  ///
  /// In en, this message translates to:
  /// **'Please enter the doctor name'**
  String get pleaseEnterDoctorName;

  /// No description provided for @pleaseEnterSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Please enter the specialty'**
  String get pleaseEnterSpecialty;

  /// No description provided for @pleaseEnterLocation.
  ///
  /// In en, this message translates to:
  /// **'Please enter the location'**
  String get pleaseEnterLocation;

  /// No description provided for @addAppointmentButton.
  ///
  /// In en, this message translates to:
  /// **'Add Appointment'**
  String get addAppointmentButton;

  /// No description provided for @deleteAppointment.
  ///
  /// In en, this message translates to:
  /// **'Delete Appointment?'**
  String get deleteAppointment;

  /// No description provided for @deleteAppointmentMessage.
  ///
  /// In en, this message translates to:
  /// **'Remove this appointment?'**
  String get deleteAppointmentMessage;

  /// No description provided for @noAppointmentsYet.
  ///
  /// In en, this message translates to:
  /// **'No appointments yet'**
  String get noAppointmentsYet;

  /// No description provided for @tapAddScheduleVisit.
  ///
  /// In en, this message translates to:
  /// **'Tap + Add to schedule a visit'**
  String get tapAddScheduleVisit;

  /// No description provided for @cherishMoments.
  ///
  /// In en, this message translates to:
  /// **'Cherish your favourite moments'**
  String get cherishMoments;

  /// No description provided for @noMemoriesYet.
  ///
  /// In en, this message translates to:
  /// **'No memories yet'**
  String get noMemoriesYet;

  /// No description provided for @deepBreathing.
  ///
  /// In en, this message translates to:
  /// **'Deep Breathing'**
  String get deepBreathing;

  /// No description provided for @deepBreathingSub.
  ///
  /// In en, this message translates to:
  /// **'5 minutes • Calm your mind'**
  String get deepBreathingSub;

  /// No description provided for @gentleStretching.
  ///
  /// In en, this message translates to:
  /// **'Gentle Stretching'**
  String get gentleStretching;

  /// No description provided for @gentleStretchingSub.
  ///
  /// In en, this message translates to:
  /// **'10 minutes • Loosen up'**
  String get gentleStretchingSub;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// No description provided for @meditationSub.
  ///
  /// In en, this message translates to:
  /// **'15 minutes • Inner peace'**
  String get meditationSub;

  /// No description provided for @sleepSounds.
  ///
  /// In en, this message translates to:
  /// **'Sleep Sounds'**
  String get sleepSounds;

  /// No description provided for @sleepSoundsSub.
  ///
  /// In en, this message translates to:
  /// **'Relaxing music'**
  String get sleepSoundsSub;

  /// No description provided for @moodCheck.
  ///
  /// In en, this message translates to:
  /// **'Mood Check'**
  String get moodCheck;

  /// No description provided for @moodCheckSub.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling today?'**
  String get moodCheckSub;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @textSize.
  ///
  /// In en, this message translates to:
  /// **'Text Size'**
  String get textSize;

  /// No description provided for @voiceAssistant.
  ///
  /// In en, this message translates to:
  /// **'Voice Assistant'**
  String get voiceAssistant;

  /// No description provided for @helpSupport.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get helpSupport;

  /// No description provided for @aboutCogniCare.
  ///
  /// In en, this message translates to:
  /// **'About CogniCare'**
  String get aboutCogniCare;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'{feature} — Coming soon'**
  String comingSoon(String feature);

  /// No description provided for @onLabel.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get onLabel;

  /// No description provided for @offLabel.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get offLabel;

  /// No description provided for @largeLabel.
  ///
  /// In en, this message translates to:
  /// **'Large'**
  String get largeLabel;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'Ramesh Kumar'**
  String get userName;

  /// No description provided for @userPhone.
  ///
  /// In en, this message translates to:
  /// **'+91 98765 43210'**
  String get userPhone;

  /// No description provided for @englishLabel.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get englishLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
