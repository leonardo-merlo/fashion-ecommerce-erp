"use client"

import { useEffect } from "react"
import { MapContainer, TileLayer, Marker, ZoomControl, useMap } from "react-leaflet"
import L from "leaflet"
import "leaflet/dist/leaflet.css"

const CITIES: { name: string; lat: number; lng: number }[] = [
  { name: "Salvador", lat: -12.9777, lng: -38.5016 },
  { name: "Belo Horizonte", lat: -19.9167, lng: -43.9345 },
  { name: "Vitória", lat: -20.3155, lng: -40.3128 },
  { name: "Rio de Janeiro", lat: -22.9068, lng: -43.1729 },
  { name: "São Paulo", lat: -23.5505, lng: -46.6333 },
  { name: "Campinas", lat: -22.9099, lng: -47.0626 },
  { name: "Curitiba", lat: -25.429, lng: -49.2671 },
  { name: "Florianópolis", lat: -27.5954, lng: -48.548 },
  { name: "Porto Alegre", lat: -30.0346, lng: -51.2177 },
  { name: "Recife", lat: -8.0476, lng: -34.877 },
  { name: "Fortaleza", lat: -3.7319, lng: -38.5267 },
  { name: "Brasília", lat: -15.7939, lng: -47.8828 },
]

const PIN_ICON = L.divIcon({
  className: "",
  html: `<div style="
    width:14px;height:14px;border-radius:50%;
    background:#ffffff;border:2.5px solid #b45309;
    box-shadow:0 1px 4px rgba(0,0,0,0.28);
  "></div>`,
  iconSize: [14, 14],
  iconAnchor: [7, 7],
})

function FitBounds() {
  const map = useMap()
  useEffect(() => {
    const bounds = L.latLngBounds(CITIES.map(({ lat, lng }) => [lat, lng] as [number, number]))
    map.fitBounds(bounds, { padding: [28, 28] })
  }, [map])
  return null
}

export function CitiesMapInner() {
  return (
    <MapContainer
      center={[-22, -44]}
      zoom={5}
      scrollWheelZoom={false}
      zoomControl={false}
      className="h-64 w-full rounded-xl md:h-72"
      aria-label="Mapa com cidades atendidas pelo Ateliê Exemplo"
    >
      <TileLayer
        url="https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png"
        attribution='&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors &copy; <a href="https://carto.com/attributions">CARTO</a>'
        subdomains="abcd"
        maxZoom={20}
      />
      <ZoomControl position="bottomright" />
      <FitBounds />
      {CITIES.map(({ name, lat, lng }) => (
        <Marker key={name} position={[lat, lng]} icon={PIN_ICON} title={name} />
      ))}
    </MapContainer>
  )
}
