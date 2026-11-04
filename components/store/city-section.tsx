"use client"

import Image from "next/image"

type CityPhoto = { image: string; city: string }

const PHOTOS: CityPhoto[] = [
  { image: "/images/hero/hero-1.jpg", city: "Vila do Mar, BA" },
  { image: "/images/hero/hero-3.jpg", city: "Rio de Janeiro, RJ" },
  { image: "/images/products/vestido-linho.jpg", city: "Florianópolis, SC" },
  { image: "/images/products/bolsa-brisa.jpg", city: "Salvador, BA" },
  { image: "/images/products/vestido-verde.jpg", city: "São Paulo, SP" },
  { image: "/images/products/bolsa-girassol.jpg", city: "Curitiba, PR" },
  { image: "/images/products/bata-bege.jpg", city: "Belo Horizonte, MG" },
  { image: "/images/products/almofada-passaro.jpg", city: "Porto Alegre, RS" },
]

export function CitySection() {
  return (
    <section className="overflow-hidden bg-surface-container-low pt-8 pb-16">
      {/* Counter header */}
      <div className="px-margin-mobile text-center md:px-margin-desktop">
        <h2 className="font-display-lg text-[28px] font-bold uppercase tracking-widest text-primary md:text-[34px]">
          Entregamos em todo o país
        </h2>
        <p className="mx-auto mt-4 max-w-md font-body-lg text-body-lg text-on-surface-variant">
          Feito no ateliê, vendido na loja e enviado para todo o Brasil.
        </p>
      </div>

      {/* Infinite city carousel */}
      <div className="mt-10 overflow-hidden">
        <div className="animate-city-scroll flex" style={{ width: "max-content" }}>
          {[...PHOTOS, ...PHOTOS].map(({ image, city }, i) => (
            <div key={i} className="w-[200px] flex-shrink-0 px-2 md:w-[260px] md:px-3">
              <div className="relative aspect-[3/4] overflow-hidden rounded-lg">
                <Image
                  src={image}
                  alt={city}
                  fill
                  className="object-cover"
                  sizes="260px"
                />
              </div>
              <p className="mt-2 text-center font-label-md text-label-md text-on-surface-variant">
                {city}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  )
}
