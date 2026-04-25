import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'product.dart';

class ProductDetailScreen extends HookWidget {
  final ProductEntity product;
  final String? heroTag;

  const ProductDetailScreen(this.product, {super.key, this.heroTag});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currencyFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: 'VNĐ',
    );

    final rawUrl = product.videoUrl;
    final cleanUrl = rawUrl.contains('&')
        ? rawUrl.substring(0, rawUrl.indexOf('&'))
        : rawUrl;
    final videoId = cleanUrl.isNotEmpty
        ? YoutubePlayer.convertUrlToId(cleanUrl) ?? ''
        : '';
    final hasVideo = videoId.isNotEmpty;
    final controller = useMemoized(
      () => hasVideo
          ? YoutubePlayerController(
              initialVideoId: videoId,
              flags: const YoutubePlayerFlags(
                autoPlay: true,
                mute: false,
                hideControls: true,
                disableDragSeek: false,
                enableCaption: false,
              ),
            )
          : null,
      [videoId],
    );
    useEffect(
      () =>
          () => controller?.dispose(),
      [controller],
    );
    void handleOrder() {
      final cartItem = CartItemEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        productId: product.id,
        title: product.title,
        quantity: 1,
        price: product.price,
        imageUrl: product.imageUrl,
        category: product.category,
        author: product.author,
        language: product.language,
        country: product.coutry,
        bookLink: product.bookLink,
      );
      BlocProvider.of<CartBloc>(context).add(AddCartEvent(cartItem));
      Navigator.of(context).pushNamed(CartScreen.routeName);
    }

    Widget buildBody() => Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(color: theme.textTheme.bodyLarge?.color),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProductMediaSlider(
              product: product,
              heroTag: heroTag,
              youtubeController: controller,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFormat.format(product.price),
                    style: const TextStyle(
                      fontSize: 22,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(height: 30),
                  _buildRowInfo("Tác giả", product.author),
                  _buildRowInfo("Thể loại", product.category),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Text(
                          "Link sách: ",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => launchUrl(Uri.parse(product.bookLink)),
                            child: Text(
                              product.bookLink,
                              style: const TextStyle(
                                color: Colors.black,
                                decoration: TextDecoration.none,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Mô tả",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: ElevatedButton(
          onPressed: handleOrder,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: const Text(
            "ĐẶT HÀNG NGAY",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
    if (hasVideo && controller != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(controller: controller),
        builder: (context, player) => buildBody(),
      );
    }

    return buildBody();
  }

  Widget _buildRowInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}
