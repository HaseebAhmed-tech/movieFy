import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:moviely/resources/constants/colors.dart';

class MinorDetailCover extends StatelessWidget {
  const MinorDetailCover(
      {super.key,
      this.height,
      this.width,
      this.movieTitle,
      this.movieCategory,
      this.releaseDate,
      this.movieLength,
      this.textWidth,
      required this.imageUrl,
      this.rating});
  final double? height;
  final double? width;
  final String? movieTitle;
  final String? movieCategory;
  final String? releaseDate;
  final String? movieLength;
  final double? textWidth;
  final String? rating;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: CachedNetworkImage(
                imageUrl: imageUrl,
                errorListener: (exception) {
                  debugPrint('Image Error: $exception');
                },
                placeholder: (context, url) => Container(
                      width: width,
                      alignment: Alignment.center,
                      child: SpinKitDoubleBounce(
                          color: Theme.of(context).primaryColor),
                    ),
                errorWidget: (context, url, error) => Container(
                    width: width,
                    alignment: Alignment.topRight,
                    child: const Icon(
                      Icons.error,
                      color: Colors.red,
                    )),
                imageBuilder: (context, imageProvider) {
                  return Container(
                    width: width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover)),
                  );
                }),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 10, bottom: 10),
              child: Column(
                // mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    constraints: BoxConstraints(maxWidth: textWidth ?? 200),
                    child: Text(movieTitle ?? 'Movie Title',
                        maxLines: 1,
                        overflow: TextOverflow.fade,
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  const SizedBox(height: 5),
                  groupedWidget(
                      const Icon(
                        Icons.star_border_outlined,
                        size: 16,
                        color: AppColors.ratingColor,
                      ),
                      rating ?? '0.0',
                      context,
                      true),
                  groupedWidget(
                      const Icon(Icons.confirmation_num_sharp, size: 16),
                      movieCategory ?? 'Genre',
                      context,
                      false),
                  groupedWidget(
                      const Icon(
                        Icons.calendar_month,
                        size: 16,
                      ),
                      releaseDate ?? '0000',
                      context,
                      false),
                  groupedWidget(
                      const Icon(
                        Icons.access_time,
                        size: 16,
                      ),
                      movieLength ?? '00 minutes',
                      context,
                      false)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget groupedWidget(Icon icon, String text, BuildContext context, isRating) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        icon,
        const SizedBox(width: 3),
        Text(
          text,
          style: isRating
              ? Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(color: AppColors.ratingColor)
              : Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
