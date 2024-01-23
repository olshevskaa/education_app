import 'package:educational_app/core/res/media_res.dart';

class PageContent {
  const PageContent({
    required this.image,
    required this.title,
    required this.description,
  });

  const PageContent.first()
      : this(
          image: MediaRes.casualReading,
          title: 'Brand new curriculum',
          description:
              'This is the first online educaiton platform designed by the '
              "world's top professors.",
        );

  const PageContent.second()
      : this(
          image: MediaRes.casualLife,
          title: 'Brand a fun atmosphere',
          description:
              'This is the first online educaiton platform designed by the '
              "world's top professors.",
        );

  const PageContent.third()
      : this(
          image: MediaRes.casualMeditationScience,
          title: 'Easy to join the lesson',
          description:
              'This is the first online educaiton platform designed by the '
              "world's top professors.",
        );

  final String image;
  final String title;
  final String description;
}
