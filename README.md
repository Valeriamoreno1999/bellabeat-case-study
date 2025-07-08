# bellabeat-case-study
Analysis of the Bellabeat case study for the Google Data Analytics Professional Certificate. Exploring fitness device usage data to generate marketing recommendations.

# Caso de Estudio Bellabeat: Análisis de Datos para una Estrategia de Marketing
## Introducción
This is my final project for the *Google Professional Certificate in Data Analytics*. The objective of this case study is to analyze fitness device usage data to gain insights into how consumers use their devices. The resulting insights will be used to guide the marketing strategies of *Bellabeat*, a high-tech company that makes wellness products for women.
# Stakeholders
**Urška Sršen:** Co-founder and Creative Director of Bellabeat.
**Sando Mur:** Co-founder and key mathematician on the executive team.
**Equipo de Marketing de Bellabeat:** Responsible for the marketing strategy.

### Ask
Business Task
Bellabeat, a technology company focused on women's wellness, seeks to better understand current trends in the use of smart health devices. The goal is to analyze data from users of these devices to identify behavioral patterns that can be applied to Bellabeat products. With this information, the company hopes to optimize its marketing strategies and make informed decisions that drive growth and market share.
The company was gaining insights into how users interact with health-tracking technology. The main challenge is to identify patterns in user behavior from wearable fitness data to uncover trends that can guide product development and marketing strategies.
These insights can drive business decisions such as improving user satisfaction, increasing device adoption, and strengthening your position in the wellness technology market.

### Prepare
The data is stored on Kaggle, from the FITBIT FITNESS TRACKER DATA dataset. The data is in wide format, with each row representing a day per user, and the columns representing the collected data, such as steps, calories, and active minutes.
ROCCC
**Reliable:** LOW. The sample size of 30 users is very small and not representative of the entire Fitbit user population.
**Original:** LOW. This is third-party data (Fitbit) collected by Amazon Mechanical Turk.
**Complete:** MEDIUM. The data includes metrics on steps, calories, sleep, and activity intensity, but lacks demographic information (age, gender, location) that would be key for marketing.
**Consistent:** BAJA. Los datos son de 2016, por lo que las tendencias pueden haber cambiado.
**Cited:** ALTA. Los datos están bien documentados y son de una fuente verificable.
Despite the limitations, the data are useful for exploratory analysis and for practicing the data analysis process.

## Tools Used
**R (Excel):** For data cleansing and transformation, as well as for statistical analysis and creating visualizations.
**GitHub:** For hosting the portfolio and documenting the process.

### Process
In this phase, I performed data cleaning and preparation to ensure data integrity before analysis.
* Null and duplicate values ​​were checked.
* Date and time formats were standardized.
* Different tables (e.g., `dailyActivity` with `dailySleep`) were joined to create a consolidated dataset.
To see the complete cleaning and transformation code, you can see the following scripts in the `code/` folder:
* [**R Script**](code/bellabeat_analysis.R)


### Analyze

Aquí se presentan algunos de los hallazgos clave del análisis exploratorio.

#### Hallazgo 1: La mayoría de la actividad se concentra en la tarde.
Los usuarios son más activos entre las 17:00 y las 19:00. Esto podría indicar que hacen ejercicio después del trabajo.

![graphic average steps per hour of day](visualizaciones/average_steps_per_hour.png)


#### Hallazgo 2: Fuerte correlación entre pasos y calorías quemadas.
Como era de esperar, hay una relación lineal positiva entre la cantidad de pasos dados y las calorías quemadas.

![Relación Pasos vs. Calorías](visualizaciones/relacion_pasos_calorias.png)

#### Hallazgo 3: El uso del dispositivo es inconsistente.
Un número significativo de usuarios no registra su actividad o sueño todos los días. Esto sugiere una oportunidad para mejorar el engagement del usuario.

---

### Fase 5: Compartir (Share)

Las visualizaciones anteriores fueron creadas para comunicar claramente los hallazgos. Se eligieron gráficos de barras y de dispersión por su simplicidad y eficacia para mostrar tendencias y relaciones. El público objetivo de esta presentación son los stakeholders de Bellabeat, por lo que los gráficos son claros, con títulos y etiquetas descriptivas para facilitar su interpretación.

*Si creaste un dashboard en Tableau, puedes poner una captura de pantalla y un enlace al dashboard público aquí.*

---

### Fase 6: Actuar (Act)

Basado en los hallazgos, aquí están mis tres principales recomendaciones para la estrategia de marketing de Bellabeat:

1.  **Recomendación 1: Fomentar el uso social y la consistencia.**
    *   **Insight:** Los usuarios a menudo dejan de usar el dispositivo.
    *   **Sugerencia:** Implementar notificaciones inteligentes y recordatorios en la app Bellabeat para motivar a los usuarios a registrar su actividad y sueño diariamente. Crear retos semanales o mensuales con recompensas virtuales podría aumentar el engagement.

2.  **Recomendación 2: Marketing enfocado en momentos clave del día.**
    *   **Insight:** La actividad física se concentra por la tarde.
    *   **Sugerencia:** Lanzar campañas de marketing en redes sociales o notificaciones push en la app Bellabeat durante la tarde (ej. "¡Es hora de moverte!") para inspirar a las usuarias a cumplir sus metas de actividad.

3.  **Recomendación 3: Resaltar los beneficios integrales de salud.**
    *   **Insight:** Los datos conectan actividad, sueño y calorías.
    *   **Sugerencia:** Crear contenido de marketing (blog, videos, posts) que eduque a las usuarias sobre cómo la actividad física (pasos) no solo quema calorías, sino que también mejora la calidad del sueño y el bienestar general, conectando todas las funciones de los productos Bellabeat (Leaf, Time, App).
