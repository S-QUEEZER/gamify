class Forums {
  String question;
  String skeptic;
  String replies;
  String answers;
  Forums(
      {required this.answers,
      required this.question,
      required this.replies,
      required this.skeptic});
}

List<Forums> forums = [
  Forums(
      answers: 'most probably Mumbai Indians',
      question: 'Who will win IPL first match 2018?',
      replies: '242',
      skeptic: 'dartista'),
  Forums(
      answers:
          'Aaron James Finch is an aggressive top-order batsman, who plays for Victoria. Known for his hard-hitting and ability to finish matches, Finch earned his spot in Australia\'s Under-19 team for the World Cup in 2006.',
      question: 'Is Aaron Finch the best batsman in the world?',
      replies: '53',
      skeptic: 'Steve'),
  Forums(
      question: 'Should a 15-year-old hit the gym?',
      answers:
          'NO Many people have many myths about gym attendance for teenagers. I started when I was 15. Gyming helps develop muscles and bones',
      replies: '43',
      skeptic: 'Fitness gawd'),
  Forums(
      answers: 'What is the highest capacity of RAM?',
      question:
          'DDR3 is where things got interesting. Limits jumped to 8GB per slot (16GB per slot on ECC) meaning even the cheapest machines could theoretically support 16GB of RAM, premium machines could support 32GB, and the prosumer level could handle 64GB.',
      replies: '654',
      skeptic: 'mark')
];
