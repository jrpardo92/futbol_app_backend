// controllers/authController.ts
import { Request, Response } from 'express';
import { AuthService } from '../services/authService';

const authService = new AuthService();

export class AuthController {
  async googleCallback(req: Request, res: Response) {
    try {
      if (!req.user) {
        return res.status(401).json({ error: 'No user data' });
      }

      const token = authService.generateToken((req.user as any).id);
      
      // Para desarrollo, puedes retornar el token directamente
      res.json({ 
        message: 'Authentication successful',
        token,
        user: req.user 
      });
      
      // Para producción, redirigir a tu app
      // res.redirect(`tu-app-scheme://auth?token=${token}`);
    } catch (error) {
      console.error('Error in googleCallback:', error);
      res.status(500).json({ error: 'Authentication failed' });
    }
  }
}