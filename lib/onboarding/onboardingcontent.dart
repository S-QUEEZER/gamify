class OnBoardingContent {
  final String title, subtitle;

  OnBoardingContent({required this.subtitle, required this.title});
}

List<OnBoardingContent> contents = [
  OnBoardingContent(
      title: 'A step toward making lives better',
      subtitle:
          'Welcome to the gropet community, click the  button and start with sign up form.'),
  OnBoardingContent(
      subtitle:
          'Just sign up, fill form and list you pet for adoption on request blood donation',
      title: 'What you need to get started'),
  OnBoardingContent(
      subtitle:
          'Sign up, and you can adopt a pet or provide blood to a needy dog, with few clicks!',
      title: 'How can you help the community')
];
