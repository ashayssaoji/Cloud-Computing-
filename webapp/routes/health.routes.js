const express = require('express');
const router = express.Router();
const healthController = require('../controllers/health.controller');

router.head('/healthz', (req, res) => {
  res.set('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.set('Pragma', 'no-cache');
  res.set('X-Content-Type-Options', 'nosniff');
  res.status(405).send(); 
});


router.get('/healthz', healthController.checkHealth);


router.all('/healthz', (req, res) => {
  res.set('Cache-Control', 'no-cache, no-store, must-revalidate');
  res.set('Pragma', 'no-cache');
  res.set('X-Content-Type-Options', 'nosniff');
  res.status(405).send(); 
});


router.all('*', (req, res) => res.status(404).send());

module.exports = router;
