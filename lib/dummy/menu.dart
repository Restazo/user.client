import 'package:restazo_user_mobile/models/menu_category.dart';
import 'package:restazo_user_mobile/models/menu_item.dart';

const menu = [
  MenuCategory(
    categoryId: "1",
    categoryLabel: "Starters",
    categoryItems: [
      MenuItem(
        id: '1',
        name: 'Crispy Calamarilskdjflsjkdflskjdflsjdflksjdlfkjsldkfjsldkfj',
        imageUrl:
            'https://images.unsplash.com/photo-1514326640560-7d063ef2aed5?q=80&w=2960&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'Golden-fried calamari served with tangy marinara sauce.skdjhfksjdfklsjdflksjdflksjdfl',
        ingredients: 'Calamari, flour, salt, pepper, marinara sauce',
        price: '12.99\$',
        // priceCurrency: 'USD',
      ),
      // MenuItem(
      //   id: '2',
      //   name: 'Bruschetta',
      //   imageUrl:
      //       'https://images.unsplash.com/photo-1574484284002-952d92456975?q=80&w=3087&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Toasted bread topped with fresh tomatoes, basil, garlic, and olive oil.',
      //   ingredients: 'Bread, tomatoes, basil, garlic, olive oil',
      //   price: '9.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '3',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '4',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '4',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '4',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '4',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '4',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
      // MenuItem(
      //   id: '4',
      //   name: 'Stuffed Mushrooms',
      //   imageUrl:
      //       'https://plus.unsplash.com/premium_photo-1674106348025-0d45c1b8ff4a?q=80&w=3164&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      //   description:
      //       'Mushroom caps filled with creamy cheese and herbs, baked to perfection.',
      //   ingredients: 'Mushrooms, cheese, herbs, breadcrumbs',
      //   price: '10.99\$',
      //   // priceCurrency: 'USD',
      // ),
    ],
  ),
  MenuCategory(
    categoryId: "2",
    categoryLabel: "Main Courses",
    categoryItems: [
      MenuItem(
        id: '4',
        name: 'Grilled Salmon',
        imageUrl:
            'https://images.unsplash.com/photo-1555126634-323283e090fa?q=80&w=3035&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
        description:
            'Fresh Atlantic salmon, grilled to perfection, served with asparagus and lemon butter sauce.',
        ingredients: 'Salmon, asparagus, lemon, butter, herbs',
        price: '24.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '5',
        name: 'Ribeye Steak',
        imageUrl:
            'https://plus.unsplash.com/premium_photo-1672242676660-923c3bd446d7?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTN8fGRpc2h8ZW58MHx8MHx8fDA%3D',
        description:
            '12 oz. prime ribeye steak, char-grilled, with mashed potatoes and seasonal vegetables.',
        ingredients: 'Ribeye steak, potatoes, seasonal vegetables, spices',
        price: '29.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '6',
        name: 'Vegetarian Lasagna',
        imageUrl:
            'https://images.unsplash.com/photo-1606850246029-dd00bd5eff97?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGRpc2h8ZW58MHx8MHx8fDA%3D',
        description:
            'Layers of pasta, ricotta, mozzarella, spinach, and marinara sauce, baked to perfection.',
        ingredients: 'Pasta, ricotta, mozzarella, spinach, marinara sauce',
        price: '18.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '6',
        name: 'Vegetarian Lasagna',
        imageUrl:
            'https://images.unsplash.com/photo-1606850246029-dd00bd5eff97?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTV8fGRpc2h8ZW58MHx8MHx8fDA%3D',
        description:
            'Layers of pasta, ricotta, mozzarella, spinach, and marinara sauce, baked to perfection.',
        ingredients: 'Pasta, ricotta, mozzarella, spinach, marinara sauce',
        price: '18.99\$',
        // priceCurrency: 'USD',
      ),
    ],
  ),
  MenuCategory(
    categoryId: "3",
    categoryLabel: "Desserts",
    categoryItems: [
      MenuItem(
        id: '7',
        name: 'Chocolate Lava Cake',
        imageUrl: '/menu_items/77777777-7777-7777-7777-777777777777.png',
        description:
            'Warm chocolate cake with a gooey center, served with vanilla ice cream.',
        ingredients: 'Chocolate, flour, sugar, eggs, vanilla ice cream',
        price: '8.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '8',
        name: 'Tiramisu',
        imageUrl: '/menu_items/88888888-8888-8888-8888-888888888888.png',
        description:
            'Classic Italian dessert with layers of coffee-soaked ladyfingers and mascarpone cream.',
        ingredients: 'Ladyfingers, coffee, mascarpone cheese, cocoa powder',
        price: '9.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '9',
        name: 'New York Cheesecake',
        imageUrl: '/menu_items/99999999-9999-9999-9999-999999999999.png',
        description:
            'Rich and creamy cheesecake with a graham cracker crust and strawberry topping.',
        ingredients: 'Cream cheese, sugar, eggs, graham cracker, strawberries',
        price: '10.99\$',
        // priceCurrency: 'USD',
      ),
    ],
  ),
  MenuCategory(
    categoryId: "4",
    categoryLabel: "Salads",
    categoryItems: [
      MenuItem(
        id: '10',
        name: 'Caesar Salad',
        imageUrl: '/menu_items/10101010-1010-1010-1010-101010101010.png',
        description:
            'Crisp romaine lettuce with parmesan, croutons, and Caesar dressing.',
        ingredients:
            'Romaine lettuce, parmesan cheese, croutons, Caesar dressing',
        price: '11.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '11',
        name: 'Greek Salad',
        imageUrl: '/menu_items/11111111-1111-1111-1111-111111111112.png',
        description:
            'Tomatoes, cucumbers, red onions, olives, and feta cheese with olive oil dressing.',
        ingredients:
            'Tomatoes, cucumbers, red onions, olives, feta cheese, olive oil',
        price: '12.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '12',
        name: 'Quinoa Salad',
        imageUrl: '/menu_items/12121212-1212-1212-1212-121212121212.png',
        description:
            'Quinoa, avocado, black beans, corn, and cilantro lime dressing.',
        ingredients: 'Quinoa, avocado, black beans, corn, cilantro, lime',
        price: '13.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '12',
        name: 'Quinoa Salad',
        imageUrl: '/menu_items/12121212-1212-1212-1212-121212121212.png',
        description:
            'Quinoa, avocado, black beans, corn, and cilantro lime dressing.',
        ingredients: 'Quinoa, avocado, black beans, corn, cilantro, lime',
        price: '13.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '12',
        name: 'Quinoa Salad',
        imageUrl: '/menu_items/12121212-1212-1212-1212-121212121212.png',
        description:
            'Quinoa, avocado, black beans, corn, and cilantro lime dressing.',
        ingredients: 'Quinoa, avocado, black beans, corn, cilantro, lime',
        price: '13.99\$',
        // priceCurrency: 'USD',
      ),
    ],
  ),
  MenuCategory(
    categoryId: "5",
    categoryLabel: "Beverages",
    categoryItems: [
      MenuItem(
        id: '13',
        name: 'Fresh Lemonade',
        imageUrl: '/menu_items/13131313-1313-1313-1313-131313131313.png',
        description: 'Freshly squeezed lemonade, sweetened to perfection.',
        ingredients: 'Lemon, water, sugar',
        price: '4.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '14',
        name: 'Iced Tea',
        imageUrl: '/menu_items/14141414-1414-1414-1414-141414141414.png',
        description: 'Classic iced tea with a hint of lemon.',
        ingredients: 'Tea, water, lemon',
        price: '3.99\$',
        // priceCurrency: 'USD',
      ),
      MenuItem(
        id: '15',
        name: 'Espresso',
        imageUrl: '/menu_items/15151515-1515-1515-1515-151515151515.png',
        description:
            'Strong and rich espresso, made from freshly ground coffee beans.',
        ingredients: 'Coffee beans, water',
        price: '2.99\$',
        // priceCurrency: 'USD',
      ),
    ],
  ),
];
