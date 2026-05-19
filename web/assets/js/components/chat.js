document.addEventListener("DOMContentLoaded", function () {
    (function () {
        var popup = document.getElementById('chatPopup');
        var pollInterval = null;
        var isOpen = false;
        var lastMsgId = 0;

        function openPopup() {
            if (!popup)
                return;
            popup.style.display = 'flex';
            isOpen = true;
            lastMsgId = 0;
            loadMessages(true);
            startPolling();
        }
        function closePopup() {
            if (!popup)
                return;
            popup.style.display = 'none';
            isOpen = false;
            stopPolling();
            hideSuggestions();
        }
        function startPolling() {
            if (pollInterval)
                clearInterval(pollInterval);
            pollInterval = setInterval(function () {
                if (isOpen)
                    loadMessages(false);
            }, 3000);
        }
        function stopPolling() {
            if (pollInterval)
                clearInterval(pollInterval);
            pollInterval = null;
        }
        async function loadMessages(forceFull) {
            try {
                var resp = await fetch(window.contextPath + '/chat?action=messages');
                if (!resp.ok)
                    return;
                var messages = await resp.json();
                var container = document.getElementById('chatMessages');
                if (!container)
                    return;
                if (forceFull) {
                    container.innerHTML = '';
                    for (var i = 0; i < messages.length; i++)
                        appendMessage(messages[i]);
                    if (messages.length > 0)
                        lastMsgId = messages[messages.length - 1].id;
                    container.scrollTop = container.scrollHeight;
                } else {
                    var newMsgs = messages.filter(function (m) {
                        return m.id > lastMsgId;
                    });
                    for (var j = 0; j < newMsgs.length; j++)
                        appendMessage(newMsgs[j]);
                    if (newMsgs.length > 0) {
                        lastMsgId = messages[messages.length - 1].id;
                        container.scrollTop = container.scrollHeight;
                    }
                }
            } catch (e) {
                console.error(e);
            }
        }
        function appendMessage(msg) {
            var container = document.getElementById('chatMessages');
            if (!container)
                return;
            var div = document.createElement('div');
            div.className = 'message ' + msg.senderType;
            div.setAttribute('data-id', msg.id);
            var time = new Date(msg.thoiGian).toLocaleTimeString('vi-VN');
            div.innerHTML = '<div class="msg-content">' + msg.noiDung + '</div><div class="time">' + time + '</div>';
            container.appendChild(div);
            div.querySelectorAll('a').forEach(function (a) {
                a.target = '_blank';
            });
        }
        async function sendMessage(text) {
            var formData = new URLSearchParams();
            formData.append('noiDung', text);
            try {
                var resp = await fetch(window.contextPath + '/chat', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/x-www-form-urlencoded'},
                    body: formData
                });
                var result = await resp.json();
                if (result.success) {
                    if (result.botMessage) {
                        setTimeout(() => {
                            var botMsg = {
                                id: result.botId || Date.now(),
                                noiDung: result.botMessage,
                                thoiGian: new Date().toISOString(),
                                senderType: 'bot'
                            };
                            appendMessage(botMsg);
                            if (container)
                                container.scrollTop = container.scrollHeight;
                            if (result.botId && result.botId > lastMsgId)
                                lastMsgId = result.botId;
                        }, 2000);
                    } else {
                        setTimeout(function () {
                            loadMessages(false);
                        }, 1000);
                    }
                } else {
                    console.error(result.error);
                }
            } catch (e) {
                console.error(e);
            }
        }
        function showSuggestions() {
            var area = document.getElementById('chatSuggestions');
            if (area)
                area.style.display = 'flex';
        }
        function hideSuggestions() {
            var area = document.getElementById('chatSuggestions');
            if (area)
                area.style.display = 'none';
        }
        function buildSuggestionBar() {
            var inputArea = document.querySelector('.chat-input-area');
            if (!inputArea || document.getElementById('chatSuggestions'))
                return;
            var bar = document.createElement('div');
            bar.id = 'chatSuggestions';
            bar.className = 'chat-suggestions';
            bar.style.display = 'none';
            var chip = document.createElement('button');
            chip.className = 'chat-suggestion-chip';
            chip.type = 'button';
            chip.innerHTML = '🔍 /tim_kiem';
            chip.title = 'Tìm kiếm sản phẩm';

            chip.addEventListener('click', function () {
                var input = document.getElementById('chatInput');
                if (input) {
                    input.value = '/tim_kiem ';
                    input.focus();
                    var len = input.value.length;
                    input.setSelectionRange(len, len);
                }
                hideSuggestions();
            });
            bar.appendChild(chip);
            inputArea.insertBefore(bar, inputArea.firstChild);
        }
        // Gắn sự kiện
        var chatLink = document.querySelector('.user-dropdown a[href*="/chat"]');
        if (chatLink)
            chatLink.addEventListener('click', function (e) {
                e.preventDefault();
                openPopup();
            });
        var closeBtn = document.querySelector('.chat-popup-close-btn');
        if (closeBtn)
            closeBtn.addEventListener('click', closePopup);
        var sendBtn = document.getElementById('chatSendBtn');
        if (sendBtn)
            sendBtn.addEventListener('click', function () {
                var input = document.getElementById('chatInput');
                var text = input ? input.value.trim() : '';
                if (!text)
                    return;
                input.value = '';
                hideSuggestions();
                sendMessage(text);
            });
        var chatInput = document.getElementById('chatInput');
        if (chatInput) {
            chatInput.addEventListener('focus', function () {
                if (!this.value.trim())
                    showSuggestions();
            });
            chatInput.addEventListener('input', function () {
                this.value.trim() ? hideSuggestions() : showSuggestions();
            });
            chatInput.addEventListener('keypress', function (e) {
                if (e.key === 'Enter' && !e.shiftKey) {
                    e.preventDefault();
                    if (sendBtn)
                        sendBtn.click();
                }
            });
        }
        buildSuggestionBar();
    })();
});