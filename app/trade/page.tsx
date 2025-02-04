import Navbar from '@/components/Navbar'
import React from 'react'

const page = () => {
  return (
    <div className="flex items-center flex-col justify-items-center font-[family-name:var(--font-geist-sans)]">
      <Navbar/>
      <div className="flex flex-col md:flex-row justify-center  p-14 pl-40">
      <h1 className='text-black text-3xl font-bold '>Coming Soon...</h1>
      </div>
    </div>
  )
}

export default page
