import 'admin.dart';

class EditProductScreen extends HookWidget {
  static const routeName = '/edit-product';
  final ProductEntity product;
  static const List<String> categories = [
    'Sách Lịch Sử',
    'Cổ tích',
    'Viễn tưởng',
    'Truyện Tranh',
    'Kinh dị',
  ];

  const EditProductScreen(ProductEntity? initialProduct, {super.key})
    : product =
          initialProduct ??
          const ProductEntity(
            id: '',
            title: '',
            category: '',
            author: '',
            language: '',
            coutry: '',
            description: '',
            price: 0,
            imageUrl: '',
            bookLink: '',
          );

  bool _isValidImageUrl(String value) {
    return value.startsWith('http') ||
        (value.startsWith('https') &&
            (value.endsWith('.png') ||
                value.endsWith('.jpg') ||
                value.endsWith('.jpeg')));
  }

  @override
  Widget build(BuildContext context) {
    final imageUrlController = useTextEditingController(text: product.imageUrl);
    final imageUrlFocusNode = useFocusNode();
    final editFormKey = useMemoized(() => GlobalKey<FormState>());
    final editedProductState = useState<ProductEntity>(product);

    useEffect(() {
      void listener() {
        if (!imageUrlFocusNode.hasFocus) {
          if (_isValidImageUrl(imageUrlController.text)) {
            editedProductState.value = editedProductState.value.copyWith(
              imageUrl: imageUrlController.text,
            );
          }
        }
      }

      imageUrlFocusNode.addListener(listener);
      return () => imageUrlFocusNode.removeListener(listener);
    }, [imageUrlFocusNode]);

    void saveForm() {
      final isValid = editFormKey.currentState!.validate();
      if (!isValid) return;

      editFormKey.currentState!.save();

      final adminBloc = BlocProvider.of<AdminProductBloc>(context);

      if (editedProductState.value.id.isNotEmpty) {
        adminBloc.add(UpdateAdminProduct(editedProductState.value));
      } else {
        adminBloc.add(AddAdminProduct(editedProductState.value));
      }
    }

    return BlocListener<AdminProductBloc, AdminProductState>(
      listener: (context, state) {
        if (state is AdminProductActionSuccess) {
          Navigator.of(context).pop();
        } else if (state is AdminProductError) {
          showErrorDialog(context, 'Có lỗi xảy ra: ${state.message}');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(product.id.isEmpty ? 'Thêm sản phẩm' : 'Chỉnh sửa'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check_rounded),
              onPressed: saveForm,
            ),
          ],
        ),
        body: BlocBuilder<AdminProductBloc, AdminProductState>(
          builder: (context, state) {
            if (state is AdminProductActionLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: editFormKey,
                child: Column(
                  children: [
                    _buildField(
                      label: 'Tên sách',
                      initialValue: editedProductState.value.title,
                      onSaved: (v) => editedProductState.value =
                          editedProductState.value.copyWith(title: v),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value:
                          categories.contains(editedProductState.value.category)
                          ? editedProductState.value.category
                          : null,
                      decoration: const InputDecoration(
                        labelText: 'Thể loại',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      onChanged: (v) {
                        editedProductState.value = editedProductState.value
                            .copyWith(category: v);
                      },
                      validator: (value) =>
                          value == null ? 'Vui lòng chọn thể loại' : null,
                    ),

                    const SizedBox(height: 12),
                    _buildField(
                      label: 'Tác giả',
                      initialValue: editedProductState.value.author,
                      onSaved: (v) => editedProductState.value =
                          editedProductState.value.copyWith(author: v),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildField(
                            label: 'Giá bán',
                            initialValue: editedProductState.value.price == 0
                                ? ''
                                : editedProductState.value.price
                                      .toInt()
                                      .toString(),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Không được để trống';
                              }
                              if (double.tryParse(value) == null ||
                                  double.parse(value) <= 0) {
                                return 'Giá không hợp lệ';
                              }
                              return null;
                            },
                            onSaved: (v) {
                              editedProductState.value = editedProductState
                                  .value
                                  .copyWith(price: double.parse(v!));
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildField(
                            label: 'Quốc gia',
                            initialValue: editedProductState.value.coutry,
                            onSaved: (v) => editedProductState.value =
                                editedProductState.value.copyWith(coutry: v),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      label: 'Mô tả',
                      initialValue: editedProductState.value.description,
                      maxLines: 3,
                      validator: (v) => (v == null || v.length < 10)
                          ? 'Mô tả quá ngắn'
                          : null,
                      onSaved: (v) => editedProductState.value =
                          editedProductState.value.copyWith(description: v),
                    ),
                    const SizedBox(height: 12),
                    _buildField(
                      label: 'Link sách',
                      initialValue: editedProductState.value.bookLink,
                      keyboardType: TextInputType.url,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Vui lòng nhập link sách';
                        }
                        final uri = Uri.tryParse(v.trim());
                        if (uri == null ||
                            !(uri.scheme == 'http' || uri.scheme == 'https')) {
                          return 'Link không hợp lệ';
                        }
                        return null;
                      },
                      onSaved: (v) =>
                          editedProductState.value = editedProductState.value
                              .copyWith(bookLink: v?.trim()),
                    ),
                    const SizedBox(height: 20),
                    _buildImagePreviewSection(
                      controller: imageUrlController,
                      focusNode: imageUrlFocusNode,
                      onSaved: (v) => editedProductState.value =
                          editedProductState.value.copyWith(imageUrl: v),
                      onFieldSubmitted: (_) => saveForm(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String initialValue,
    required Function(String?) onSaved,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator:
          validator ?? (value) => value!.isEmpty ? 'Không được để trống' : null,
      onSaved: onSaved,
    );
  }

  Widget _buildImagePreviewSection({
    required TextEditingController controller,
    required FocusNode focusNode,
    required Function(String?) onSaved,
    required Function(String) onFieldSubmitted,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 80,
          height: 110,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          alignment: Alignment.center,
          child: controller.text.isEmpty
              ? const Icon(Icons.image_not_supported, color: Colors.grey)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: AppCachedImage(
                    url: controller.text,
                    width: 80,
                    height: 110,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextFormField(
            controller: controller,
            focusNode: focusNode,
            decoration: const InputDecoration(
              labelText: 'Link ảnh sản phẩm',
              hintText: 'https://...',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.url,
            onFieldSubmitted: onFieldSubmitted,
            onSaved: onSaved,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng nhập URL';
              if (!_isValidImageUrl(value)) {
                return 'URL không đúng định dạng ảnh';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
