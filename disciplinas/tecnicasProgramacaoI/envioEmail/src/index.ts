import fs from "fs";
import csv from "csv-parser";
import nodemailer from "nodemailer";
import dotenv from "dotenv";
import { calcularIdade, mesSeguinte } from "./utils";

dotenv.config();

// === CONFIGURAÇÃO DO TRANSPORTADOR DE E-MAIL ===
const transporter = nodemailer.createTransport({
  host: "smtp.gmail.com",
  port: 587,
  secure: false, // true para 465, false para 587
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

interface Cliente {
  Nome: string;
  Email: string;
  Nasc: string;
}

// === LER ARQUIVOS ===
const mensagemBase = fs.readFileSync("src/mensagem.html", "utf-8");

// === LER CSV E ENVIAR ===
fs.createReadStream("src/emails.csv")
  .pipe(csv({ separator: ";" }))
  .on("data", async (row: Cliente) => {
    const idade = calcularIdade(row.Nasc);
    const proximoMes = mesSeguinte(row.Nasc);

    // Substituir campos no HTML
    const mensagemPersonalizada = mensagemBase
      .replace(/{{nome}}/g, row.Nome)
      .replace(/{{percdesc}}/g, idade.toString())
      .replace(/{{mesquevem}}/g, proximoMes);

    // Configurar e-mail
    const mailOptions = {
      from: `"Cas E-sports" <${process.env.EMAIL_USER}>`,
      to: row.Email,
      subject: `Parabéns, ${row.Nome}! 🎉`,
      html: mensagemPersonalizada,
      attachments: [
        { filename: "logo.png", path: "logo.png", cid: "logo@cid" },
        { filename: "assinatura.png", path: "assinatura.png", cid: "assinatura@cid" },
      ],
    };

    try {
      const info = await transporter.sendMail(mailOptions);
      console.log(`E-mail enviado para ${row.Nome}: ${info.messageId}`);
    } catch (error) {
      console.error(`Erro ao enviar e-mail para ${row.Nome}:`, error);
    }
  })
  .on("end", () => {
    console.log("Processamento de aniversariantes concluído.");
  });
