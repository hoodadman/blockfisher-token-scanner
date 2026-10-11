import { access } from "node:fs/promises";

await access(new URL("./dist/index.html", import.meta.url));
console.log("using prebuilt dist");
