import fetch from "node-fetch";

export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export class ProductDataMap {
  private static _productDataMap: { [productId: string]: ProductData } = {};

  public static async instance(productId: string) {
    if (Object.keys(ProductDataMap._productDataMap).length == 0) {
      const response = await fetch("http://localhost:3000/laudyou-api/cash/product-list-external");
      const data = await response.json();
      const products = data as [{productId: string, productType: string}];

      for (let i = 0; i < products.length; i++) {
        const product = products[i];
        ProductDataMap._productDataMap[product["productId"]] = {
          productId: product["productId"],
          type: product["productType"] as "SUBSCRIPTION" | "NON_SUBSCRIPTION"
        };
      }
    }

    return ProductDataMap._productDataMap[productId];
  }
}
