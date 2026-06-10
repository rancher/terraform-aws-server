import js from "@eslint/js";
import globals from "globals";

export default [
  js.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.node,
      },
    },
    rules: {
      // Per .agent/rules/github-script.instructions.md: Use core.* instead of console.*
      "no-console": "error",
    },
  },
];
