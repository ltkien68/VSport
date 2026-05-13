const memberCtx =
        document.getElementById("weeklyMemberChart");

const memberLoading =
        document.querySelector(".member-chart-skeleton");

async function loadMemberChart() {

    try {

        const response = await fetch(
                contextPath +
                "/admin/dashboard/thong-ke-tuan?type=thanh_vien"
                );

        const text = await response.text();

        console.log(text);

        const data = JSON.parse(text);

        console.log(data);

        setTimeout(() => {

            memberLoading.classList.add("hide");

            new Chart(memberCtx, {

                type: 'radar',

                data: {

                    labels: data.map(i => i.weekName),

                    datasets: [{

                            label: 'Thành Viên Mới',

                            data: data.map(i => i.value),

                            borderColor: '#e63946',

                            backgroundColor:
                                    'rgba(230,57,70,.18)',

                            pointBackgroundColor: '#e63946',

                            pointBorderColor: '#fff',

                            pointHoverBackgroundColor: '#111',

                            pointHoverBorderColor: '#fff',

                            pointRadius: 5,

                            pointHoverRadius: 8,

                            borderWidth: 3
                        }]
                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    animations: {

                        r: {

                            duration: 1800,

                            easing: 'easeOutQuart',

                            from: 0
                        }
                    },

                    scales: {

                        r: {

                            beginAtZero: true,

                            ticks: {

                                stepSize: 1,

                                precision: 0,

                                color: '#111',

                                backdropColor: 'transparent'
                            },

                            grid: {
                                color: 'rgba(0,0,0,.08)'
                            },

                            angleLines: {
                                color: 'rgba(0,0,0,.08)'
                            },

                            pointLabels: {
                                color: '#111',
                                font: {
                                    size: 13,
                                    weight: '600'
                                }
                            }
                        }
                    }
                }
            });

        }, 800);

    } catch (error) {

        console.error(
                "Lỗi load member chart:",
                error
                );
    }
}

loadMemberChart();