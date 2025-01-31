import React, { useState } from "react";

const HomePage = () => {
  const [input, setInput] = useState<string>("");
  const [imageUrl, setImageUrl] = useState<string | null>(null);
  const [loading, setLoading] = useState<boolean>(false);

  const generateMeme = async () => {
    setLoading(true);
    if (!input.trim()) return;

    const formData = new FormData();
    formData.append("prompt", input);

    try {
      const response = await fetch("https://clipdrop-api.co/text-to-image/v1", {
        method: "POST",
        headers: {
          "x-api-key": process.env.NEXT_PUBLIC_CLIPDROP_API_KEY || "",
        },
        body: formData,
      });

      if (!response.ok) {
        const errorData = await response.json();
        console.log("Error:", errorData);
        return;
      }

      const blob = await response.blob();
      const imageUrl = URL.createObjectURL(blob);
      setImageUrl(imageUrl); // Update state with image URL
    } catch (error) {
      console.error("Failed to generate meme:", error);
    } finally{
      setLoading(false)
    }
  };

  const handleDownload = () => {
    if (!imageUrl) return;
    const link = document.createElement("a");
    link.href = imageUrl;
    link.download = `${input}.png`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  };

  
  const handleMint = () => {
    alert("Minting functionality will be implemented!");
    // Integrate with Web3 minting logic here
  };

  return (
    <div className="flex flex-col mb-10 items-center justify-center w-full mt-20 text-black">
      {/* Input Field with Generate Button */}
      <div className="relative p-5 w-[600px]">
        <input
          type="text"
          placeholder="Describe your meme idea..."
          value={input}
          onChange={(e) => setInput(e.target.value)}
          className="bg-white w-full border-2 border-black rounded-full 
                     text-black shadow-[4px_4px_5px_#171717,-4px_4px_10px_#171717] 
                     py-3 px-5 outline-none text-lg font-medium pr-24"
        />
        <button
          onClick={generateMeme}
          className="absolute right-8 top-1/2 transform -translate-y-1/2 
                     bg-black text-white font-bold px-5 py-2 rounded-full 
                     hover:bg-gray-800 transition duration-300"
        >
          Generate
        </button>
      </div>

      {/* Show loading spinner or generated image */}
      {loading ? (
        <div className="mt-10 flex flex-col items-center">
          <div className="w-[512px] h-[512px] bg-gray-300 flex items-center justify-center rounded-lg animate-pulse">
            <span className="text-xl font-bold text-gray-700">
              Generating...
            </span>
          </div>
        </div>
      ) : imageUrl ? (
        <div className="flex flex-col items-center mt-10">
          <img
            src={imageUrl}
            alt="Generated Meme"
            className="w-[512px] h-[512px] rounded-lg shadow-lg"
          />

          {/* Download & Mint Buttons */}
          <div className="flex gap-5 mt-5 w-full">
            <button
              onClick={handleDownload}
              className="bg-[#ffffff] w-1/2 border border-black rounded-md text-black shadow-[-4px_4px_0px_#171717] font-bold py-2 px-4  hover:bg-black hover:shadow-yellow-300 hover:text-white transition-all duration-300"

            >
              Download
            </button>

            <button
              onClick={handleMint}
              className="bg-[#f5e56b] w-1/2 border border-black rounded-md text-black shadow-[-4px_4px_0px_#171717] font-bold py-2 px-4  hover:bg-black hover:shadow-yellow-300 hover:text-white transition-all duration-300"

            >
              Mint
            </button>
          </div>
        </div>


      ) : (
        <div className="w-2/6 mt-10 p-5 text-left">
          <h1 className="text-3xl font-extrabold text-black mb-4 relative inline-block">
            Some Ideas
            <span className="absolute left-0 bottom-[-5px] w-full h-1 bg-black"></span>
          </h1>

          <ul className="text-lg mt-10 font-medium space-y-3">
            {[
              "Create a meme image of a unicorn",
              "A dog playing with a ball",
              "Elon Musk riding a Shiba Inu to the moon",
              "A cat sleeping under the blanket",
            ].map((idea) => (
              <li
                key={idea}
                className="flex items-center gap-2 cursor-pointer hover:text-yellow-50 transition"
                onClick={() => setInput(idea)}
              >
                {idea}
              </li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
};

export default HomePage;
