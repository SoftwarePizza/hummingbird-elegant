const fs = require('fs');
const path = require('path');
const themeDev = path.resolve(__dirname, '../src');

const envFilePath = './webpack/.env';

if (fs.existsSync(envFilePath)) {
  require('dotenv').config({path: envFilePath});
}

const {
  PORT: port = null,
  PUBLIC_PATH: publicPath = null,
  SERVER_ADDRESS: serverAddress = null,
  SITE_URL: siteURL = null,
} = process.env;

const entriesArray = {
  theme: ['scss', 'ts'],
  error: ['scss'],
  theme_rtl: ['scss'],
  error_rtl: ['scss'],
  rtl: ['scss'],
  // [izpol] Dodatki sklepu: src/scss/custom.scss + src/js/custom.js →
  // assets/css/custom.css i assets/js/custom.js. Rdzeń rejestruje oba
  // w FrontController::setMedia() ('theme-custom', priorytet 1000).
  custom: ['scss', 'js'],
};

// [izpol] output.library wystawia każde wejście jako window.Theme — drugie
// wejście JS nadpisałoby eksporty motywu. Wejścia z tej listy dostają
// własną nazwę (moduł nic nie eksportuje, więc ląduje tam pusty obiekt).
const entryLibraries = {
  custom: { name: 'ThemeCustom', type: 'window' },
};

exports.webpackVars = {
  themeDev,
  publicPath,
  serverAddress,
  siteURL,
  port,
  entriesArray,
  getEntry: (entries) => {
    const resultEntries = {};

    for (const entry in entries) {
      const files = [];

      if (!entries.hasOwnProperty(entry)) {
        continue;
      }

      for (const ext in entries[entry]) {
        const extension = entries[entry][ext];

        files.push(path.resolve(themeDev, `./${extension === 'ts' ? 'js' : extension}/${entry}.${extension}`));
      }

      resultEntries[entry] = entryLibraries[entry]
        ? { import: files, library: entryLibraries[entry] }
        : files;
    }

    return resultEntries;
  },
  getOutput: ({
    mode, publicPath, siteURL, port, serverAddress,
  }) => ({
    filename: 'js/[name].js',
    chunkFilename: mode === 'production' ? 'js/[chunkhash].js' : 'js/[id].js',
    path: path.resolve(themeDev, '../assets'),
    publicPath: mode === 'production' || !siteURL ? '../' : `${serverAddress === 'localhost' ? siteURL : `${siteURL}:${port}`}${publicPath}`,
    pathinfo: false,
    library: {
      name: 'Theme',
      type: 'window',
    }
  }),
};
