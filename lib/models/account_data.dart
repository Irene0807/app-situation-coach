class AccountData {
  String name;
  int age;
  EnglishLevel englishLevel;
  ExamScore examScore;
  DailyStudyTime dailyStudyTime;
  StudyPlace studyPlace;
  bool englishAppExperience;
  String appFeedback;

  AccountData({
    required this.name,
    required this.age,
    required this.englishLevel,
    required this.examScore,
    required this.dailyStudyTime,
    required this.studyPlace,
    required this.englishAppExperience,
    required this.appFeedback,
  });
}

enum EnglishLevel { beginner, intermediate, advanced }

class ExamScore {
  int toeic;
  int toefl;
  int ielts;
  int gept;

  ExamScore(
      {this.toeic = -1, this.toefl = -1, this.ielts = -1, this.gept = -1});
}

enum DailyStudyTime {
  lessThan30Min,
  between30MinAnd1Hour,
  between1HourAnd3Hours,
  moreThan3Hours
}

enum StudyPlace { school, coffeeShop, home, online }
