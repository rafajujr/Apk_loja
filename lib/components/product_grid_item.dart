import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/models/auth.dart';
import 'package:shop/models/cart.dart';
import 'package:shop/models/product.dart';

import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);
    final msg = ScaffoldMessenger.of(context);
    final auth = Provider.of<Auth>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: const Color.fromARGB(144, 0, 0, 0),
          leading: Consumer<Product>(
            builder: (context, product, _) => IconButton(
              onPressed: () async {
                final response = await product.toggleFavorite(
                    auth.token.toString(), auth.userId ?? '');
                if (response == false) {
                  msg.showSnackBar(const SnackBar(
                    content: Text(
                      'Erro conexão com o banco de dados',
                    ),
                  ));
                }
              },
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text(
                    'Produto adicionado com sucesso!',
                  ),
                  duration: const Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'Desfazer',
                    onPressed: () {
                      cart.removeSinlgeItem(product.id);
                    },
                  ),
                ),
              );
              cart.additem(product);
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).splashColor,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder:
                  const AssetImage('assets/images/imagem_loading.jpg.jpg'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          /*
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),*/
        ),
      ),
    );
  }
}
