import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/product.dart';
import 'package:shop/models/product_list.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      onTap: () {
        Provider.of<ProductList>(context, listen: false).loadProducts();
      },
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.name),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCTS_FORM,
                  arguments: product,
                );
              },
              color: Colors.green[900],
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text(
                      'Tem certeza?',
                      style: TextStyle(fontSize: 18),
                    ),
                    content: Text('Excluir o item ${product.name}'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: const Text('Não'),
                      ),
                      TextButton(
                        onPressed: () async {
                          Navigator.of(context).pop(true);

                          try {
                            await Provider.of<ProductList>(
                              context,
                              listen: false,
                            ).removeProduct(product);
                          } catch (error) {
                            msg.showSnackBar(SnackBar(
                              content: Text(
                                'Não foi possivel excluir o produto Error: $error',
                              ),
                            ));
                          }
                        },
                        child: const Text('Sim'),
                      ),
                    ],
                  ),
                );
              },
              color: Colors.red[900],
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
