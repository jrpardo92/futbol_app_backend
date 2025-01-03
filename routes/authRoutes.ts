import express from 'express';
import passport from '../config/passport';
import { AuthController } from '../controllers/authController';

const router = express.Router();
const authController = new AuthController();

router.get(
  '/google',
  passport.authenticate('google', { scope: ['profile', 'email'] })
);

router.get(
  '/google/callback',
  passport.authenticate('google', { session: false }),
  authController.googleCallback
);

export default router;