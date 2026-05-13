const revenueCtx =
        document.getElementById("weeklyRevenueChart");

const revenueLoading =
        document.querySelector(".chart-skeleton");

async function loadRevenueChart() {

    try {

        const response = await fetch(contextPath + "/admin/dashboard/thong-ke-tuan?type=doanh_thu");

        const text = await response.text();

        console.log(text);

        const data = JSON.parse(text);

        console.log(data);

        setTimeout(() => {

            revenueLoading.classList.add("hide");

            new Chart(revenueCtx, {

                type: 'line',

                data: {

                    labels: data.map(i => i.weekName),

                    datasets: [{

                            label: 'Doanh Thu',

                            data: data.map(i => i.value),

                            borderColor: '#e63946',

                            backgroundColor:
                                    'rgba(230,57,70,.15)',

                            fill: true,

                            tension: .4,

                            pointRadius: 5,

                            pointBackgroundColor: '#e63946',

                            pointBorderColor: '#fff',

                            pointBorderWidth: 2,

                            pointHoverRadius: 8,

                            pointHoverBackgroundColor: '#111',
                        }]
                },

                options: {

                    responsive: true,

                    maintainAspectRatio: false,

                    interaction: {
                        intersect: false,
                        mode: 'index'
                    },

                    animations: {

                        tension: {
                            duration: 1800,
                            easing: 'easeOutQuart',
                            from: 1,
                            to: 0.4
                        },

                        y: {
                            duration: 1800,
                            easing: 'easeOutQuart',
                            from: (ctx) => {

                                if (ctx.type === 'data') {
                                    return ctx.chart.scales.y.getPixelForValue(0);
                                }

                                return 0;
                            }
                        }
                    },

                    plugins: {

                        legend: {

                            labels: {
                                color: '#111',
                                font: {
                                    size: 13,
                                    weight: '600'
                                }
                            }
                        },

                        tooltip: {

                            backgroundColor: '#111',

                            titleColor: '#fff',

                            bodyColor: '#fff',

                            padding: 12,

                            cornerRadius: 10
                        }
                    },

                    scales: {

                        x: {

                            ticks: {
                                color: '#111'
                            },

                            grid: {
                                display: false
                            }
                        },

                        y: {

                            ticks: {
                                color: '#111'
                            },

                            grid: {
                                color: 'rgba(0,0,0,.06)'
                            }
                        }
                    }
                }
            });

        }, 800);

    } catch (error) {

        console.error(
                "Lỗi load revenue chart:",
                error
                );
    }
}

loadRevenueChart();