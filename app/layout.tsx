import type { Metadata } from 'next'
import localFont from 'next/font/local'
import './globals.css'

// Fontes versionadas no repositório: com next/font/google o build baixava do
// Google na hora e falhava no CI quando o download falhava.
const fraunces = localFont({
  src: [
    { path: './fonts/fraunces-latin.woff2', weight: '400 600', style: 'normal' },
    { path: './fonts/fraunces-italic-latin.woff2', weight: '400 600', style: 'italic' },
  ],
  variable: '--font-playfair',
  display: 'swap',
})

const mulish = localFont({
  src: './fonts/mulish-latin.woff2',
  weight: '400 700',
  variable: '--font-be-vietnam',
  display: 'swap',
})

export const metadata: Metadata = {
  title: 'Ateliê Exemplo',
  description: "Moda artesanal brasileira — bolsas, vestidos e batas feitos à mão. Presentes em Vila do Mar, BA e em todo o Brasil.",
  openGraph: {
    title: 'Ateliê Exemplo',
    description: "Moda artesanal brasileira — bolsas, vestidos e batas feitos à mão. Presentes em Vila do Mar, BA e em todo o Brasil.",
    url: 'https://atelieexemplo.com.br',
    siteName: 'Ateliê Exemplo',
    locale: 'pt_BR',
    type: 'website',
    images: ['/images/hero/hero-2.jpg'],
  },
  twitter: {
    card: 'summary_large_image',
    images: ['/images/hero/hero-2.jpg'],
  },
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html
      lang="pt-BR"
      className={`${fraunces.variable} ${mulish.variable}`}
    >
      <body className="antialiased">
        {children}
      </body>
    </html>
  )
}
