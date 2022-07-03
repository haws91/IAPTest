// import fetch from "node-fetch";

export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export class ProductDataMap {
  private static _productDataMap: { [productId: string]: ProductData } = {};

  public static async instance(productId: string) {
    if (Object.keys(ProductDataMap._productDataMap).length == 0) {
      ProductDataMap._productDataMap = {
        "test.9900": {
          productId: "test.9900",
          type: "NON_SUBSCRIPTION",
        },
        "test.30000": {
          productId: "test.30000",
          type: "NON_SUBSCRIPTION",
        },
        "test.50000": {
          productId: "test.50000",
          type: "NON_SUBSCRIPTION",
        },
      };
    }

    return ProductDataMap._productDataMap[productId];
  }
}
