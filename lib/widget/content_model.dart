class UnboardingContent {
  String image;
  String title;
  String description;
  UnboardingContent(
      {required this.description, required this.image, required this.title});
}

List<UnboardingContent> contents = [
  UnboardingContent(
      description:
          'Break language barriers with ease\nConvert signs into text in real time',
      image: 'images/com.png',
      title: 'Seamless Sign to Text Conversion'),
  UnboardingContent(
      description:
          'Instantly translate sign language to text\nCommunicate effectively with everyone',
      image: 'images/com 1.png',
      title: 'Real-Time Communication'),
  UnboardingContent(
      description:
          "Stay connected and understand \n the world around you better",
      image: 'images/com 2.png',
      title: 'Bridge the Communication Gap'),
];
