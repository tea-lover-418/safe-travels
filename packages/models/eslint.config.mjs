import { config } from '@safe-travels/eslint-config/base';
import tseslint from 'typescript-eslint';

/** @type {import("eslint").Linter.Config} */
const localConfig = [
  {
    languageOptions: {
      parserOptions: {
        projectService: {
          allowDefaultProject: ['*.js', '*.mjs'],
        },
        tsconfigRootDir: import.meta.dirname,
      },
    },
  },
  ...config,
];
export default tseslint.config(localConfig);
