import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'product.dart';

class ProductMediaSlider extends StatefulWidget {
  final ProductEntity product;
  final String? heroTag;
  final YoutubePlayerController? youtubeController;

  const ProductMediaSlider({
    super.key,
    required this.product,
    this.heroTag,
    this.youtubeController,
  });

  @override
  State<ProductMediaSlider> createState() => _ProductMediaSliderState();
}

class _ProductMediaSliderState extends State<ProductMediaSlider> {
  int _currentPage = 0;
  late final List<String> _mediaList;
  late final bool _hasValidVideo;
  late final int _totalPages;
  bool _isControllerReady = false;

  @override
  void initState() {
    super.initState();
    _mediaList = [
      widget.product.imageUrl,
      ...widget.product.images.where((e) => e.isNotEmpty),
    ];
    _hasValidVideo = widget.youtubeController != null;
    _totalPages = _mediaList.length + (_hasValidVideo ? 1 : 0);
    widget.youtubeController?.addListener(_onControllerUpdate);
  }

  void _onControllerUpdate() {
    if (!_isControllerReady &&
        widget.youtubeController?.value.isReady == true) {
      _isControllerReady = true;
      if (_currentPage == _totalPages - 1) {
        widget.youtubeController?.play();
      }
    }
  }

  @override
  void dispose() {
    widget.youtubeController?.removeListener(_onControllerUpdate);
    super.dispose();
  }

  void _onPageChanged(int i) {
    setState(() => _currentPage = i);
    final isVideoPage = _hasValidVideo && i == _totalPages - 1;
    if (isVideoPage) {
      if (_isControllerReady) {
        widget.youtubeController?.play();
      }
    } else {
      widget.youtubeController?.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        SizedBox(
          height: 350,
          child: PageView.builder(
            itemCount: _totalPages,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              if (_hasValidVideo && index == _totalPages - 1) {
                return YoutubePlayer(
                  controller: widget.youtubeController!,
                  showVideoProgressIndicator: false,
                  onReady: () {
                    _isControllerReady = true;
                    if (_currentPage == _totalPages - 1) {
                      widget.youtubeController?.play();
                    }
                  },
                );
              }
              if (index == 0) {
                return Hero(
                  tag: widget.heroTag ?? widget.product.id,
                  child: AppCachedImage(
                    url: _mediaList[index],
                    fit: BoxFit.contain,
                  ),
                );
              }
              return AppCachedImage(
                url: _mediaList[index],
                fit: BoxFit.contain,
              );
            },
          ),
        ),
        if (_totalPages > 1)
          Positioned(
            bottom: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_totalPages, (i) {
                final isActive = i == _currentPage;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.redAccent : Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }
}
