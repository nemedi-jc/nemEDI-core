# 🧩 Installation af nemEDI Core i Business Central

Denne guide viser, hvordan du installerer *nemEDI Core*-modulet i din Business Central-løsning.  
Modulet giver nemEDI mulighed for at genåbne salgsordrer via API’et — med præcis samme login og sikkerhed, som I allerede bruger i dag.

---

## 🔹 Trin 1 – Upload og installer modulet
1. Gå til **Business Central**  
   👉 [https://businesscentral.dynamics.com/](https://businesscentral.dynamics.com/)  
2. Gå til **Søg** (forstørrelsesglas) → skriv **Udvidelsesstyring** (*Extension Management*).  
3. Klik **Administrer → Upload udvidelse** (*Manage → Upload Extension*).  
4. Vælg filen `nemEDI_nemEDI Core_1.0.0.0.app` (som du har modtaget fra nemEDI).  
5. Vælg **Installér** og vent, til status viser *Installeret*.

---

## 🔹 Trin 2 – Tildel rettigheder
1. Gå til **Brugere** (*Users*).  
2. Find den **Application User**, som er knyttet til jeres eksisterende *Entra App* (den bruges til nemEDI’s API-adgang).  
3. Åbn brugeren og tilføj følgende permission set:  
   ✅ **nemEDI CORE – Reopen Sales Orders**  
   (Dette permission set følger automatisk med modulet.)  

---

## 🔹 For teknisk interesserede
Modulet tilføjer et sikkert API-endpoint i jeres Business Central, som nemEDI’s system kan kalde for at genåbne salgsordrer automatisk.  
Dette sker med jeres eksisterende OAuth-token og med BC’s egne valideringsregler.


