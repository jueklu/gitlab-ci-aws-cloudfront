export default [
    {
      ignores: ["node_modules"],
    },
    {
      files: ["public/js/**/*.js"],
      languageOptions: {
        sourceType: "module",
        ecmaVersion: "latest",
      },
      rules: {
        "no-unused-vars": "warn",
        "no-console": "off",
        "indent": ["warn", 4],
        "quotes": ["error", "double"],
        "semi": ["error", "always"]
      },
    },
  ];