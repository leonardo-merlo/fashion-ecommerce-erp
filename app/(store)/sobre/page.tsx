import type { Metadata } from "next"
import Image from "next/image"
import { Separator } from "@/components/ui/separator"

export const metadata: Metadata = {
  title: "Nossa História | Ateliê Exemplo",
  description:
    "Ateliê de bordado à mão com loja em Vila do Mar (BA) e envio para todo o Brasil. Marca fictícia de demonstração.",
}

const VALUES = [
  {
    title: "Design autoral",
    body: "Cada estampa nasce de um risco feito à mão antes de virar peça. O bordado é o desenho, não um enfeite em cima dele.",
  },
  {
    title: "Materiais naturais",
    body: "Linho, algodão cru e lona. Materiais que respiram, envelhecem bem e aguentam o uso de todo dia.",
  },
  {
    title: "Feito no ateliê",
    body: "Corte, costura e bordado acontecem sob o mesmo teto. Cada peça passa por mão humana em todas as etapas.",
  },
]

export default function SobrePage() {
  return (
    <div>
      {/* Hero */}
      <section className="mx-auto max-w-container px-margin-mobile py-16 md:px-margin-desktop">
        <div className="text-center">
          <p className="font-label-md text-label-md uppercase tracking-widest text-primary">
            Nossa História
          </p>
          <h1 className="mt-3 font-display-lg text-display-lg-mobile text-on-surface md:text-display-lg">
            Feito à mão,{" "}
            <span className="italic text-primary">uma de cada vez.</span>
          </h1>
          <p className="mx-auto mt-5 max-w-2xl font-body-lg text-body-lg text-on-surface-variant">
            O Ateliê Exemplo é uma marca fictícia, criada para demonstrar este sistema. A
            história abaixo é inventada; o fluxo de produção que ela descreve é o que o
            painel administrativo controla de verdade.
          </p>
        </div>
      </section>

      <Separator />

      {/* Nossa Essência */}
      <section className="mx-auto max-w-container px-margin-mobile py-14 md:px-margin-desktop">
        <div className="grid grid-cols-1 gap-12 md:grid-cols-2 md:items-center">
          <div>
            <h2 className="font-headline-md text-headline-md font-bold uppercase text-on-surface">
              Como funciona o ateliê
            </h2>
            <div className="mt-4 space-y-4 font-body-lg text-body-lg text-on-surface-variant">
              <p>
                Uma bolsa começa na ficha técnica: quais peças de lona, forro e couro ela
                leva, e quantas ferragens.
              </p>
              <p>
                As peças são cortadas em lote e guardadas por cor. Quando chega um pedido,
                a ordem de produção confere se há corte suficiente antes de ir para a costura.
              </p>
              <p>
                Depois vem o bordado, feito à mão no bastidor, e a peça pronta entra no
                estoque da loja.
              </p>
              <p className="font-semibold text-on-surface">
                Se a peça chegar na sua casa e você quiser usar no mesmo dia, a gente fez certo.
              </p>
            </div>
            <div className="mt-6 flex flex-wrap gap-3">
              <span className="rounded-full border border-primary px-4 py-1.5 font-label-md text-label-md uppercase tracking-wider text-primary">
                Bordado à mão
              </span>
              <span className="rounded-full border border-primary px-4 py-1.5 font-label-md text-label-md uppercase tracking-wider text-primary">
                Desenho autoral
              </span>
              <span className="rounded-full border border-primary px-4 py-1.5 font-label-md text-label-md uppercase tracking-wider text-primary">
                Produção sob demanda
              </span>
            </div>
          </div>

          <div className="relative aspect-[4/3] overflow-hidden rounded-xl">
            <Image
              src="/images/atelie/maos-costurando.jpg"
              alt="Mãos costurando tecido no ateliê"
              fill
              className="object-cover"
            />
          </div>
        </div>
      </section>

      <Separator />

      {/* Valores */}
      <section className="mx-auto max-w-container px-margin-mobile py-14 md:px-margin-desktop">
        <h2 className="mb-10 text-center font-headline-md text-headline-md font-bold uppercase text-on-surface">
          O que acreditamos
        </h2>
        <div className="grid grid-cols-1 gap-8 md:grid-cols-3">
          {VALUES.map(({ title, body }) => (
            <div key={title} className="rounded-xl bg-surface-container-low p-6">
              <p className="font-headline-sm text-headline-sm text-primary">{title}</p>
              <p className="mt-3 font-body-md text-body-md text-on-surface-variant">{body}</p>
            </div>
          ))}
        </div>
      </section>

      <Separator />

      {/* Vila do Mar — full bleed */}
      <section>
        <div className="relative h-[55vh] w-full overflow-hidden md:h-[72vh]">
          <Image
            src="/images/atelie/litoral.jpg"
            alt="Litoral perto da loja"
            fill
            className="object-cover object-center"
            priority
          />
        </div>

        <div className="mx-auto max-w-container px-margin-mobile py-14 text-center md:px-margin-desktop">
          <h2>
            <span className="block font-display-lg text-4xl font-bold uppercase leading-tight text-on-surface md:text-5xl">
              Da loja
            </span>
            <span className="block font-display-lg text-4xl font-bold uppercase leading-tight text-primary md:text-5xl">
              para o Brasil
            </span>
          </h2>
          <div className="mx-auto mt-6 max-w-2xl space-y-4 font-body-lg text-body-lg text-on-surface-variant">
            <p>
              A loja física fica no litoral; o ateliê e o estoque ficam na sede, de onde
              saem as entregas.
            </p>
            <p>
              <strong>Quem não passa pela loja compra pelo site, e a gente manda para todo o Brasil.</strong>
            </p>
          </div>
        </div>

        <div className="grid grid-cols-3 gap-[3px] bg-white">
          <div className="relative aspect-[9/16] md:aspect-[4/3]">
            <Image
              src="/images/atelie/bastidor.jpg"
              alt="Bordado no bastidor"
              fill
              className="object-cover object-center"
            />
          </div>
          <div className="relative aspect-[9/16] md:aspect-[4/3]">
            <Image
              src="/images/products/bata-branca.jpg"
              alt="Bata bordada"
              fill
              className="object-cover object-[50%_30%]"
            />
          </div>
          <div className="relative aspect-[9/16] md:aspect-[4/3]">
            <Image
              src="/images/atelie/afiliadas-loja.jpg"
              alt="Clientes na entrada da loja"
              fill
              className="object-cover object-center"
            />
          </div>
        </div>

        <div className="bg-neutral-900 py-5 text-center">
          <p className="font-label-md text-label-md uppercase tracking-widest text-white">
            VILA DO MAR • BAHIA • RUA EXEMPLO, 100
          </p>
        </div>
      </section>
    </div>
  )
}
