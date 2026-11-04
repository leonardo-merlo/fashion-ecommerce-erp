import { MetadataRoute } from 'next'

export default function robots(): MetadataRoute.Robots {
  return {
    rules: [
      {
        userAgent: '*',
        allow: '/',
        disallow: ['/admin/', '/admin', '/afiliada/', '/afiliada', '/api/', '/conta/'],
      },
    ],
    sitemap: 'https://atelieexemplo.com.br/sitemap.xml',
  }
}
