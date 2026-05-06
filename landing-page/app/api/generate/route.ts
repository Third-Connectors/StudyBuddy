import { GoogleGenerativeAI } from "@google/generative-ai";
import { NextResponse } from "next/server";

const genAI = new GoogleGenerativeAI(process.env.NEXT_PUBLIC_GEMINI_API_KEY || "");

export async function POST(req: Request) {
  try {
    const { topic, subject, difficulty, count, mode, context } = await req.json();

    const model = genAI.getGenerativeModel({ model: "gemini-1.5-flash" });

    let prompt = "";
    if (mode === "questions") {
      prompt = `
        Anda adalah asisten guru profesional. Buatlah ${count} soal pilihan ganda (A, B, C, D) untuk mata pelajaran ${subject} dengan topik "${topic}".
        Tingkat kesulitan: ${difficulty}.
        
        ${context ? `PENTING: Buatlah soal HANYA berdasarkan konteks materi berikut ini:\n"${context}"` : ""}

        Format output HARUS berupa JSON array seperti ini (jangan ada teks lain):
        [
          {
            "subject": "${subject}",
            "topic": "${topic}",
            "question_text": "Teks soal di sini...",
            "options": {
              "A": "Pilihan A",
              "B": "Pilihan B",
              "C": "Pilihan C",
              "D": "Pilihan D"
            },
            "correct_option": "A",
            "difficulty": "${difficulty}",
            "explanation": "Penjelasan mengapa jawaban tersebut benar..."
          }
        ]
      `;
    } else {
      prompt = `
        Buatlah materi pembelajaran mendalam mengenai "${topic}" untuk mata pelajaran ${subject} yang dioptimalkan untuk gaya belajar VAK (Visual, Auditory, Kinesthetic).
        
        Struktur Materi:
        1. Ringkasan Umum
        2. Tipe VISUAL: Berikan kode Mermaid.js untuk Diagram konsep dan deskripsi visual yang menarik. Berikan juga 2 rekomendasi judul pencarian YouTube yang relevan.
        3. Tipe AUDITORY: Berikan narasi penjelasan singkat yang enak dibaca keras dan analogi suara/ritme jika ada.
        4. Tipe KINESTHETIC: Berikan 1 instruksi aktivitas/praktik seru yang bisa dilakukan siswa untuk memahami topik ini.

        Gunakan format Markdown yang indah.
      `;
    }

    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();

    if (mode === "questions") {
      // Clean potential markdown code blocks
      const cleanJson = text.replace(/```json|```/g, "").trim();
      return NextResponse.json({ data: JSON.parse(cleanJson) });
    } else {
      return NextResponse.json({ data: text });
    }
  } catch (error: any) {
    console.error("AI Generation Error:", error);
    return NextResponse.json({ error: error.message }, { status: 500 });
  }
}
