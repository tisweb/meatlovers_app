import 'package:flutter/material.dart';
import 'package:meatlovers_app/provider/category.dart';
import 'package:provider/provider.dart';

import '../provider/products.dart';
import '../provider/categories.dart';
import '../provider/product.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _catTitleFocusNode = FocusNode();
  final _weight1FocusNode = FocusNode();
  final _weight2FocusNode = FocusNode();
  final _weight3FocusNode = FocusNode();
  final _price1FocusNode = FocusNode();
  final _price2FocusNode = FocusNode();
  final _price3FocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  List<DropdownMenuItem<Category>> _dropdownMenuItems = [];
  Category _selectedCategory;
  var _editedProduct = Product(
    id: null,
    categoryTitle: '',
    title: '',
    weight1: '',
    weight2: '',
    weight3: '',
    price1: 0,
    price2: 0,
    price3: 0,
    description: '',
    imageUrl: '',
  );

  var _initValues = {
    'categoryTitle': '',
    'title': '',
    'description': '',
    'weight1': '',
    'weight2': '',
    'weight3': '',
    'price1': '',
    'price2': '',
    'price3': '',
    'imageUrl': '',
  };
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _editedProduct =
            Provider.of<Products>(context, listen: false).finById(productId);
        _initValues = {
          'categoryTitle': _editedProduct.categoryTitle,
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'weight1': _editedProduct.weight1.toString(),
          'weight2': _editedProduct.weight2.toString(),
          'weight3': _editedProduct.weight3.toString(),
          'price1': _editedProduct.price1.toString(),
          'price2': _editedProduct.price2.toString(),
          'price3': _editedProduct.price3.toString(),
          // 'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        _imageUrlController.text = _editedProduct.imageUrl;
      }

      final categoriesDate = Provider.of<Categories>(context);
      final List<Category> categories = categoriesDate.items;
      int i = 0;
      for (Category category in categories) {
        _dropdownMenuItems.add(
          DropdownMenuItem(
            value: category,
            child: Text(category.title),
          ),
        );

        if (productId != null) {
          if (_editedProduct.categoryTitle == category.title) {
            _selectedCategory = _dropdownMenuItems[i].value;
          }
        }
        i++;
      }

      if (productId == null) {
        _selectedCategory = _dropdownMenuItems[0].value;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _catTitleFocusNode.dispose();
    _weight1FocusNode.dispose();
    _weight2FocusNode.dispose();
    _weight3FocusNode.dispose();
    _price1FocusNode.dispose();
    _price2FocusNode.dispose();
    _price3FocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if ((!_imageUrlController.text.startsWith('http') &&
              !_imageUrlController.text.startsWith('https')) ||
          (!_imageUrlController.text.endsWith('.png') &&
              !_imageUrlController.text.endsWith('.jpg') &&
              !_imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_editedProduct);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
      // finally {
      //   setState(() {
      //     _isLoading = false;
      //   });
      //   Navigator.of(context).pop();
      // }

      // .catchError((error) { no need of this line if we use asysn
      // return
      // }).then((_) { no need of this line if we use asysn
      // setState(() {
      //   _isLoading = false;
      // });
      // Navigator.of(context).pop();
      // }); no need of this line if we use asysn
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // _selectedCategory = _dropdownMenuItems[0].value;

    onChangeDropdownItem(Category selectedCategory) {
      setState(() {
        _selectedCategory = selectedCategory;
        _editedProduct = Product(
          id: _editedProduct.id,
          categoryTitle: _selectedCategory.title,
          isFavorite: _editedProduct.isFavorite,
          title: _editedProduct.title,
          description: _editedProduct.description,
          weight1: _editedProduct.weight1,
          weight2: _editedProduct.weight2,
          weight3: _editedProduct.weight3,
          price1: _editedProduct.price1,
          price2: _editedProduct.price2,
          price3: _editedProduct.price3,
          imageUrl: _editedProduct.imageUrl,
        );
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_catTitleFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a title.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          categoryTitle: _editedProduct.categoryTitle,
                          isFavorite: _editedProduct.isFavorite,
                          title: value,
                          description: _editedProduct.description,
                          weight1: _editedProduct.weight1,
                          weight2: _editedProduct.weight2,
                          weight3: _editedProduct.weight3,
                          price1: _editedProduct.price1,
                          price2: _editedProduct.price2,
                          price3: _editedProduct.price3,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Select a category'),

                    DropdownButton(
                      value: _selectedCategory,
                      items: _dropdownMenuItems,
                      onChanged: onChangeDropdownItem,
                      focusNode: _catTitleFocusNode,
                      // onTap: () {
                      //   _editedProduct = Product(
                      //     id: _editedProduct.id,
                      //     catId: _selectedCategory.title,
                      //     isFavorite: _editedProduct.isFavorite,
                      //     title: _editedProduct.title,
                      //     description: _editedProduct.description,
                      //     price: _editedProduct.price,
                      //     imageUrl: _editedProduct.imageUrl,
                      //   );
                      // },
                    ),
                    // Text(_selectedCategory.title),
                    // Text('Selecte: ${_selectedCategory.title}'),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // TextFormField(
                    //   // initialValue: _initValues['catId'],
                    //   initialValue: categories[0].title,
                    //   // initialValue: _selectedCategory.title,
                    //   decoration: InputDecoration(labelText: 'Category ID'),
                    //   textInputAction: TextInputAction.next,
                    //   onFieldSubmitted: (_) {
                    //     FocusScope.of(context).requestFocus(_priceFocusNode);
                    //   },
                    //   validator: (value) {
                    //     if (value.isEmpty) {
                    //       return 'Please provide a Cat ID.';
                    //     }
                    //     return null;
                    //   },
                    //   onSaved: (value) {
                    //     _editedProduct = Product(
                    //       id: _editedProduct.id,
                    //       catId: _selectedCategory.title,
                    //       isFavorite: _editedProduct.isFavorite,
                    //       title: _editedProduct.title,
                    //       description: _editedProduct.description,
                    //       price: _editedProduct.price,
                    //       imageUrl: _editedProduct.imageUrl,
                    //     );
                    //   },
                    // ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: '1 KG',
                            decoration:
                                InputDecoration(labelText: 'Weight 1 KG'),
                            textInputAction: TextInputAction.next,
                            focusNode: _weight1FocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_price1FocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a weight.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: value,
                                weight2: _editedProduct.weight2,
                                weight3: _editedProduct.weight3,
                                price1: _editedProduct.price1,
                                price2: _editedProduct.price2,
                                price3: _editedProduct.price3,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: _initValues['price1'],
                            decoration:
                                InputDecoration(labelText: 'Price 1 KG'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _price1FocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_weight2FocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a price greater than 0.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: _editedProduct.weight1,
                                weight2: _editedProduct.weight2,
                                weight3: _editedProduct.weight3,
                                price1: double.parse(value),
                                price2: _editedProduct.price2,
                                price3: _editedProduct.price3,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                        ),
                      ],
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: '500 GMS',
                            decoration:
                                InputDecoration(labelText: 'Weight 500 GMS'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _weight2FocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_price2FocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a weight.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: _editedProduct.weight1,
                                weight2: value,
                                weight3: _editedProduct.weight3,
                                price1: _editedProduct.price1,
                                price2: _editedProduct.price2,
                                price3: _editedProduct.price3,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: _initValues['price2'],
                            decoration:
                                InputDecoration(labelText: 'Price 500 GMS'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _price2FocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_weight3FocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a price greater than 0.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: _editedProduct.weight1,
                                weight2: _editedProduct.weight2,
                                weight3: _editedProduct.weight3,
                                price1: _editedProduct.price1,
                                price2: double.parse(value),
                                price3: _editedProduct.price3,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: '250 GMS',
                            decoration:
                                InputDecoration(labelText: 'Weight 250 GMS'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _weight3FocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_price3FocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please provide a weight.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: _editedProduct.weight1,
                                weight2: _editedProduct.weight2,
                                weight3: value,
                                price1: _editedProduct.price1,
                                price2: _editedProduct.price2,
                                price3: _editedProduct.price3,
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 75,
                          child: TextFormField(
                            initialValue: _initValues['price3'],
                            decoration:
                                InputDecoration(labelText: 'Price 250 GMS'),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            focusNode: _price3FocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a price.';
                              }
                              if (double.tryParse(value) == null) {
                                return 'Please enter a valid number.';
                              }
                              if (double.parse(value) <= 0) {
                                return 'Please enter a price greater than 0.';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: _editedProduct.weight1,
                                weight2: _editedProduct.weight2,
                                weight3: _editedProduct.weight3,
                                price1: _editedProduct.price1,
                                price2: _editedProduct.price2,
                                price3: double.parse(value),
                                imageUrl: _editedProduct.imageUrl,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: InputDecoration(labelText: 'Description'),
                      maxLines: 3,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a description.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                          id: _editedProduct.id,
                          categoryTitle: _editedProduct.categoryTitle,
                          isFavorite: _editedProduct.isFavorite,
                          title: _editedProduct.title,
                          description: value,
                          weight1: _editedProduct.weight1,
                          weight2: _editedProduct.weight2,
                          weight3: _editedProduct.weight3,
                          price1: _editedProduct.price1,
                          price2: _editedProduct.price2,
                          price3: _editedProduct.price3,
                          imageUrl: _editedProduct.imageUrl,
                        );
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    _imageUrlController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onChanged: (value) => setState(() {}),
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid URL.';
                              }
                              // if (!value.endsWith('.png') &&
                              //     !value.endsWith('.jpg') &&
                              //     !value.endsWith('.jpg')) {
                              //   return 'Please enter a valid image URL.';
                              // }
                              return null;
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                id: _editedProduct.id,
                                categoryTitle: _editedProduct.categoryTitle,
                                isFavorite: _editedProduct.isFavorite,
                                title: _editedProduct.title,
                                description: _editedProduct.description,
                                weight1: _editedProduct.weight1,
                                weight2: _editedProduct.weight2,
                                weight3: _editedProduct.weight3,
                                price1: _editedProduct.price1,
                                price2: _editedProduct.price2,
                                price3: _editedProduct.price3,
                                imageUrl: value,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
