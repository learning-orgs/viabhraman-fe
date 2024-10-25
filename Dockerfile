# Step 1: Build the React app using Vite
FROM node:20 as build

WORKDIR /app

# Copy package.json and package-lock.json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the React application for production using Vite
RUN npm run build

# Step 2: Set up Nginx to serve the build files
FROM nginx:alpine

# Copy the build folder from the previous stage into the Nginx HTML folder
COPY --from=build /app/dist /usr/share/nginx/html

# Adjust the path to your nginx.conf
# If `nginx.conf` is in the project root:
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]
