import { Metadata } from 'next';
import { LoginScreen } from '../../screens/login';

export const revalidate = 10;

export default async function Login() {
  return <LoginScreen></LoginScreen>;
}

export const generateMetadata = async (): Promise<Metadata> => {
  return {
    title: 'Safe Travels',
  };
};
