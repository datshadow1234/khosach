import 'package:intl/intl.dart';

import 'order_screen_widget.dart';

class OrderDetailScreen extends StatefulWidget {
  static const routeName = 'order-detail-screen';
  final OrderEntity order;

  const OrderDetailScreen(this.order, {super.key});

  @override
  State<OrderDetailScreen> createState() => OrderDetailScreenState();
}

class OrderDetailScreenState extends State<OrderDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lịch sử đơn hàng'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(left: 5),
                      child: const Text(
                        'Ngày đặt',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                        ),
                      )),
                  Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 5),
                    child: Text(DateFormat('dd/MM/yyyy hh:mm')
                        .format(widget.order.dateTime)),
                  ),
                ],
              ),
              const Divider(),
              Container(
                  padding: EdgeInsets.all(20),
                  child: buildPaymentDetailScreen()),
            ],
          ),
        ));
  }

  Widget buildPaymentDetailScreen() {
    return Container(
        width: 500,
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
            border: Border.all(
                color: Colors.teal, width: 2, style: BorderStyle.solid),
            borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            buildNameRow(),
            const SizedBox(height: 20),
            buildPhoneRow(),
            const SizedBox(height: 20),
            buildAddressRow(),
            const Divider(
              color: Colors.black,
            ),
            buildNameProductRow(),
            buildOrderDetails(),
            const Divider(
              color: Colors.black,
            ),
            buildTotalQuantity(),
            const SizedBox(height: 20),
            buildTotalAmountRow(),
            const SizedBox(height: 20),
            buildCategoryRow(),
            const SizedBox(height: 20),
            buildAuthorRow(),
            const SizedBox(height: 20),
            buildLanguageRow(),
            const SizedBox(height: 20),
            buildCoutryRow(),
            const SizedBox(height: 20),
            buildStatusPayment(),
            const SizedBox(height: 20),
          ],
        ));
  }

  Widget buildOrderDetails() {
    return SizedBox(width: 400,height: widget.order.productCount*30, child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      // height: min(widget.order.productCount * 20.0 + 40, 150),
      child: ListView(
        children: widget.order.products
            .map(
              (prod) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    prod.title,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${prod.quantity}x${prod.price}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    ),);
  }

  Widget buildNameRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Họ và tên',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.name}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildPhoneRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Số điện thoại',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.phone}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildCategoryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'The loai',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.products.first.category}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }
    Widget buildAuthorRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Nguoi ban',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.products.first.author}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildCoutryRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Quoc gia',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.products.first.country}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildLanguageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Ngon ngu',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.products.last.language}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildAddressRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Địa chỉ',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20, left: 40),
            child: Text(
              '${widget.order.address}',
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNameProductRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Tên sản phẩm',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text("Số lượng x giá",
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildTotalAmountRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Tổng thanh toán',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.amount}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildTotalQuantity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Tổng số lượng',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.totalQuantity}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }

  Widget buildStatusPayment() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
            padding: EdgeInsets.only(left: 20),
            child: const Text(
              'Hình thức',
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            )),
        Container(
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 20),
          child: Text('${widget.order.payResult}',
              style: TextStyle(fontSize: 16, color: Colors.black)),
        ),
      ],
    );
  }
}
