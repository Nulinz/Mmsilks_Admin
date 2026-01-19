class ConnectionService {
  //*****************Live URl ****************/
  // static var base_url = "https://mmsilks.in/beta/api";
  static var base_url = "https://mmsilks.in/api";
  static var update_popup = "$base_url/admin_popup";

  //product
  static var productList = "$base_url/product-list";
  static var categoryDropList = "$base_url/category_list";

  //category
  static var categoryStore = "$base_url/category-store";
  static var categoryList = "$base_url/category-list";
  static var categoryEdit = "$base_url/category-edit";
  static var categoryUpdate = "$base_url/category-update";

  //subcategory
  static var subCategoryList = "$base_url/subcategory_fetch_list";
  static var addSubCategory = "$base_url/subcategory-store";
  static var subcategoryEdit = "$base_url/subcategory-edit";
  static var subcategoryUpdate = "$base_url/subcategory-update";

  //items
  static var itemList = "$base_url/item_fetch_list";
  static var dropdownList = "$base_url/admin_dropdown_list";
  static var itemStore = "$base_url/items-store";
  static var editItem = "$base_url/items-edit";
  static var updateItem = "$base_url/item-update";
}
