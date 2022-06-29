export interface ProductData {
  productId: string;
  type: "SUBSCRIPTION" | "NON_SUBSCRIPTION";
}

export const productDataMap: { [productId: string]: ProductData } = {
  "laud.u.test.74636575": {
    productId: "laud.u.test.74636575",
    type: "NON_SUBSCRIPTION",
  },
  "laud.u.test.56357245": {
    productId: "laud.u.test.56357245",
    type: "NON_SUBSCRIPTION",
  },
  "laud.u.test.35668233": {
    productId: "laud.u.test.35668233",
    type: "NON_SUBSCRIPTION",
  },
};
